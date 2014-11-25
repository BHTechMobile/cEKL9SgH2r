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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    eventListModel = [EventListModel new];
    [self refreshListEventsAction:nil];
    
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
    cell.timeTitleEvents.text = [NSString stringWithFormat:@"From %@ to %@",eventsDetails.eventStartTime ,eventsDetails.eventEndTime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:SEGUE_INDENTIFIER sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:SEGUE_INDENTIFIER]) {
        EventDetailViewController *edvc = (EventDetailViewController *)[segue destinationViewController];
        [edvc setEvent:nil];
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
