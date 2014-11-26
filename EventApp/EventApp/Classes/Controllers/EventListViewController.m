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
    NSArray *arrayEvents;
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
    return arrayEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = TABLE_IDENTIFIER_ID_ID;
    EventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:SEGUE_INDENTIFIER sender:nil];
    
    [eventDetailViewController setEvent:[arrayEvents objectAtIndex:indexPath.row]];
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
        arrayEvents = eventListModel.arrayEvents;
        [self.listEventsTable reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
}

@end
