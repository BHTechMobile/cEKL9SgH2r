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
    [self refreshListEventsAction:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor  = MAIN_COLOR;
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: MAIN_COLOR}];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        EAEventsDetails* eventsDetails = [self.searchListEvents objectAtIndex:indexPath.row];
        cell.titleEvents.text = eventsDetails.titleName;
        
        NSDate *startTime = eventsDetails.eventStartTime;
        NSDate *endTime = eventsDetails.eventEndTime;
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
        [dataFormatter setDateFormat:FORMAT_SHORT_DATE];
        
        [dataFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *dateAsStringEnd = [dataFormatter stringFromDate:endTime];
        NSString *dateAsStringStart = [dataFormatter stringFromDate:startTime];
        
        cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",dateAsStringStart ,dateAsStringEnd];
    } else {
        EAEventsDetails* eventsDetails = [arrayEvents objectAtIndex:indexPath.row];
        cell.titleEvents.text = eventsDetails.titleName;
        
        NSDate *startTime = eventsDetails.eventStartTime;
        NSDate *endTime = eventsDetails.eventEndTime;
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
        [dataFormatter setDateFormat:FORMAT_SHORT_DATE];
        
        [dataFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *dateAsStringEnd = [dataFormatter stringFromDate:endTime];
        NSString *dateAsStringStart = [dataFormatter stringFromDate:startTime];
        
        cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",dateAsStringStart ,dateAsStringEnd];
    }
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
    [eventListModel getEventsSuccess:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        arrayEvents = [NSMutableArray arrayWithArray:eventListModel.arrayEvents];
        [self.listEventsTable reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.searchListEvents removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.titleName contains[c] %@",searchText];
    self.searchListEvents = [NSMutableArray arrayWithArray:[arrayEvents filteredArrayUsingPredicate:resultPredicate]];
}

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


@end
