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

@interface EventListViewController ()

@end

@implementation EventListViewController{
    NSDictionary *dictEvents;
    NSArray *arrayEvents;
    EventDetailViewController *eventDetailViewController;
    EAEventsDetails *eaEventsDetails;
    EventListModel *eventListModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    eventListModel = [EventListModel new];
    [eventListModel getJSONfile];
    arrayEvents = eventListModel.arrayEvents;
    [self.listEventsTable reloadData];
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
    return arrayEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = TABLE_IDENTIFIER_ID_ID;
    EventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    eaEventsDetails = [arrayEvents objectAtIndex:indexPath.row];
    
    cell.titleEvents.text = [[[arrayEvents objectAtIndex:indexPath.row] valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY];
    
    
    // timestamp conversion
    NSString *endReceivedInString = [[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:END_TIME_MAIN_KEY];
    NSString *startReceivedInString =[[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:START_TIME_MAIN_KEY];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:FORMAT_SHORT_DATE];
    NSDate *dt = [formatter dateFromString:[endReceivedInString substringToIndex:LENGTH_SHORT_DATE_TIME]];
    NSDate *dt2 = [formatter dateFromString:[startReceivedInString substringToIndex:LENGTH_SHORT_DATE_TIME]];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateAsStringEnd = [formatter stringFromDate:dt];
    NSString *dateAsStringStart = [formatter stringFromDate:dt2];

    cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",dateAsStringStart ,dateAsStringEnd];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:SEGUE_INDENTIFIER sender:nil];
    eventDetailViewController.navigationItem.title = [[[arrayEvents objectAtIndex:indexPath.row] valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY];
    [eventDetailViewController setEventsTitle:[[[arrayEvents objectAtIndex:indexPath.row] valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY]];
    [eventDetailViewController setEventsLocation:[[[[arrayEvents objectAtIndex:indexPath.row] valueForKey:WHERE_MAIN_KEY]firstObject]valueForKey:VALUE_STRING_MAIN_KEY]];
    [eventDetailViewController setEventsDescription:[[[arrayEvents objectAtIndex:indexPath.row] valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY]];
    
    [eventDetailViewController setEventsEndTime:[[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:END_TIME_MAIN_KEY]];
    [eventDetailViewController setEventsStartTime:[[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:START_TIME_MAIN_KEY]];
    
    [eventDetailViewController setEventsCreatedby:eventListModel.createdBy];
    [eventDetailViewController setEventsCalendar:eventListModel.nameCalendar];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:SEGUE_INDENTIFIER]) {
        eventDetailViewController = [segue destinationViewController];
    }
}

- (IBAction)refreshListEventsAction:(id)sender {
    [eventListModel insertData:arrayEvents];
}

@end
