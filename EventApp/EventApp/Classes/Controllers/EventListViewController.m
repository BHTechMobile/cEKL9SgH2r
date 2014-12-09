//
//  EventListViewController.m
//  EventApp
//
//  Created by Tommy on 11/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import "EAEventsDetails.h"
#import "AppDelegate.h"
#import "EventListTableViewCell.h"
#import "JSONLoader.h"
#import "EventListModel.h"
#import <MBProgressHUD.h>


#define HEIGHT_SEARCH_BAR_CONSTAINT_DEFAULT 44
#define TOP_SPACE_SEARCH_BAR_CONSTAINT_DEFAULT 20
@interface EventListViewController ()

@end

@implementation EventListViewController{
    NSDictionary *dictEvents;
    NSMutableArray *arrayEvents;
    EventListModel *eventListModel;
    EventDetailViewController *eventDetailViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    eventListModel = [EventListModel new];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"checkFirst"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"checkFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.refreshListEvents.enabled = NO;
        [self refreshListEventsAction:nil];
    }else{
        arrayEvents = [NSMutableArray arrayWithArray:eventListModel.arrayEvents];
        [self updateData];
    }
    
    _heightSearchBarConstaints.constant = 0;
    [self.view layoutIfNeeded];
    
}

-(void)updateData{
    [self.listEventsTable reloadData];
    NSInteger todayIndex = eventListModel.todayIndex;
    if (todayIndex!=-1) {
        [self.listEventsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:todayIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    self.refreshListEvents.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.listEventsTable reloadData];
    self.title = @"BayArea Startup Events";
    self.navigationController.navigationBar.tintColor  = MAIN_COLOR;
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: MAIN_COLOR}];
    [[UISearchBar appearance] setTintColor: MAIN_COLOR];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_LIST_EVENT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchListEvents.count;
    } else{
        return arrayEvents.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = TABLE_IDENTIFIER_ID_ID;
    EventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    EAEventsDetails* eventsDetails;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        eventsDetails = [self.searchListEvents objectAtIndex:indexPath.row];
    } else {
        eventsDetails = [arrayEvents objectAtIndex:indexPath.row];
    }
    if ([eventListModel isToday:eventsDetails.eventStartTime]) {
        cell.titleEvents.textColor = MAIN_COLOR;
    }
    else if  ([EventListModel isFuture:eventsDetails.eventStartTime]) {
        cell.titleEvents.textColor = [UIColor blackColor];
    }
    else {
        cell.titleEvents.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0  blue:100.0/255.0  alpha:1];
    }
   
    cell.titleEvents.text = eventsDetails.titleName;
    
    NSDate *startTime = eventsDetails.eventStartTime;
    NSDate *endTime = eventsDetails.eventEndTime;
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:FORMAT_SHORT_DATE];
    
    [dataFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateAsStringEnd = [dataFormatter stringFromDate:endTime];
    NSString *dateAsStringStart = [dataFormatter stringFromDate:startTime];
    
    cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",dateAsStringStart ,dateAsStringEnd];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:SEGUE_INDENTIFIER sender:nil];
    if (tableView == self.searchDisplayController.searchResultsTableView){
        [eventDetailViewController setEvent:[self.searchListEvents objectAtIndex:indexPath.row]];
    }else{
        [eventDetailViewController setEvent:[arrayEvents objectAtIndex:indexPath.row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:SEGUE_INDENTIFIER]) {
        eventDetailViewController = [segue destinationViewController];
    }
}

- (IBAction)refreshListEventsAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.refreshListEvents.enabled = NO;
    [eventListModel getEventsSuccess:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        arrayEvents = [NSMutableArray arrayWithArray:eventListModel.arrayEvents];
        [self updateData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.refreshListEvents.enabled = YES;
    }];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.searchListEvents removeAllObjects];
    NSPredicate *resultPredicateTitle = [NSPredicate predicateWithFormat:@"(SELF.titleName contains[c] %@) OR (SELF.eventWhere contains[c] %@ ) OR (SELF.contentDescription contains[c] %@) OR (SELF.eventCalendarName contains[c] %@) OR (SELF.eventCreatedBy contains[c] %@)",searchText,searchText,searchText,searchText,searchText];
    self.searchListEvents = [NSMutableArray arrayWithArray:[arrayEvents filteredArrayUsingPredicate:resultPredicateTitle]];}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}


- (IBAction)searchListViewEvents:(id)sender {
    _heightSearchBarConstaints.constant = HEIGHT_SEARCH_BAR_CONSTAINT_DEFAULT;
    _topSpaceSearchBarConstaints.constant = TOP_SPACE_SEARCH_BAR_CONSTAINT_DEFAULT;
    [self.view layoutIfNeeded];
    [self.searchDisplayController setActive:YES animated:YES];
    
}



@end
