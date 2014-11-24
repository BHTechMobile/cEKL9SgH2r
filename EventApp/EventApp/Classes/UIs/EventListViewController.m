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
    self.navigationController.navigationBar.tintColor  = [UIColor redColor];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
    
    cell.titleEvents.text = [[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"title"]valueForKey:@"$t"];
    
    
    // timestamp conversion
    NSString *endReceivedInString = [[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:@"gd$when"]firstObject] valueForKey:@"endTime"];
    NSString *startReceivedInString =[[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:@"gd$when"]firstObject] valueForKey:@"startTime"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS-HH:mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    NSDate *dateStringEnd= [dateFormatter dateFromString:[endReceivedInString substringToIndex:10]];
    NSDate *dateStringStart= [dateFormatter dateFromString:[startReceivedInString substringToIndex:10]];
    
    cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",[startReceivedInString substringToIndex:10],[endReceivedInString substringToIndex:10]];

//    cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",dateStringStart,dateStringEnd];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"viewEventDetails" sender:nil];
    eventDetailViewController.navigationItem.title = [[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"title"]valueForKey:@"$t"];
    [eventDetailViewController setEventsTitle:[[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"title"]valueForKey:@"$t"]];
    [eventDetailViewController setEventsLocation:[[[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"gd$where"]firstObject]valueForKey:@"valueString"]];
    [eventDetailViewController setEventsDescription:[[[arrayEvents objectAtIndex:indexPath.row] valueForKey:@"content"]valueForKey:@"$t"]];
    
    [eventDetailViewController setEventsEndTime:[[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:@"gd$when"]firstObject] valueForKey:@"endTime"]];
    [eventDetailViewController setEventsStartTime:[[[[arrayEvents objectAtIndex:indexPath.row]valueForKey:@"gd$when"]firstObject] valueForKey:@"startTime"]];
    
    [eventDetailViewController setEventsCreatedby:eventListModel.createdBy];
    [eventDetailViewController setEventsCalendar:eventListModel.nameCalendar];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewEventDetails"]) {
        eventDetailViewController = [segue destinationViewController];
    }
}

- (IBAction)refreshListEventsAction:(id)sender {
    [eventListModel insertData:arrayEvents];
}

@end
