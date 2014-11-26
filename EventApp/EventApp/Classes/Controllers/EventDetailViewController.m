//
//  EventDetailViewController.m
//  EventApp
//
//  Created by Tommy on 11/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventDetailTableViewCell.h"
#import "EventDetailMapTableViewCell.h"
#import "EventDescriptionTableViewCell.h"
#import "EventListModel.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface EventDetailViewController ()<EventDetailMapTableViewCellDelegate>{
    EventListModel *eventListModel;
}

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    eventListModel = [EventListModel new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.title = self.event.titleName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    if (indexPath.row == 0){
        EventDetailTableViewCell *cell = (EventDetailTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }
    else if (indexPath.row == 1){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 20;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0 || [self.event.eventWhere isEqualToString:@"Unknown Location"])?1:0)){
        EventDetailMapTableViewCell *cell = (EventDetailMapTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + cell.contentTitle.frame.size.height;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0)?1:0 || [self.event.eventWhere isEqualToString:@"Unknown Location"])+ ((self.event.eventCalendarName.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0)?1:0 || [self.event.eventWhere isEqualToString:@"Unknown Location"])+ ((self.event.eventCalendarName.length > 0)?1:0)+ ((self.event.eventCreatedBy.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0)?1:0 || [self.event.eventWhere isEqualToString:@"Unknown Location"])+ ((self.event.eventCalendarName.length > 0)?1:0)+ ((self.event.eventCreatedBy.length > 0)?1:0) + ((self.event.contentDescription.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 20;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + ((self.event.eventWhere.length > 0|| [self.event.eventWhere isEqualToString:@"Unknown Location"])?1:0)+ ((self.event.eventCalendarName.length > 0)?1:0) + ((self.event.eventCreatedBy.length > 0)?1:0) + ((self.event.contentDescription.length > 0)?1:0) ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    if (indexPath.row == 0){
        //Title
        EventDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        [cell.contentDetailEvents setText:self.event.titleName];
        cell.contentDetailEvents.font = [UIFont fontWithName:FONT_HELVETICA_BOLD size:14];
        [cell.contentDetailEvents sizeToFit];
        CGRect textFrame = cell.contentDetailEvents.frame;
        textFrame.size.width = 290;
        cell.contentDetailEvents.frame = textFrame;
        
        CGRect containerFrame = cell.contentDetailEvents.frame;
        containerFrame.size.height = cell.contentDetailEvents.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }
    else if (indexPath.row == 1){
        //Time
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        
        cell.contentDescriptionLabel.text = TITLE_TIME;
        
        NSDate *startTime = self.event.eventStartTime;
        NSDate *endTime = self.event.eventEndTime;
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
        [dataFormatter setDateFormat:FORMAT_DATE];
        
        [dataFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dataFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateAsStringEnd = [dataFormatter stringFromDate:endTime];
        NSString *dateAsStringStart = [dataFormatter stringFromDate:startTime];
        
        cell.contentDescription.text = [NSString stringWithFormat:@"From %@ \n to %@",dateAsStringStart ,dateAsStringEnd];
        
        [cell.contentDescription sizeToFit];
        CGRect textFrame = cell.contentDescription.frame;
        textFrame.size.width = WIDTH_CONTENT_CELL_DETAIL;
        cell.contentDescription.frame = textFrame;
        
        CGRect containerFrame = cell.contentDescription.frame;
        containerFrame.size.height = cell.contentDescription.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0 || [self.event.eventWhere isEqualToString:@"Unknown Location"])?1:0)){
        //Map
        EventDetailMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailMapTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDetailMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailMapTableViewCell_ID];
        }
        if (cell.contentLocation.text.length==0) {
            cell.contentLocation.text = [NSString stringWithFormat:@"%@",self.event.eventWhere];
        }
        
        [cell setDelegate:self];
        [cell.mapButton setTag:indexPath.row];
        
        cell.contentTitle.text = TITLE_LOCATION;
        
        [cell.contentLocation sizeToFit];
        
        CGRect fMap = [cell.contentTitle frame];
        fMap.size.width = WIDTH_CONTENT_CELL_DETAIL;
        [cell.contentTitle setFrame:fMap];
        
        CGRect textFrame = cell.contentLocation.frame;
        textFrame.size.width = WIDTH_CONTENT_CELL_DETAIL;
        textFrame.origin.y = CGRectGetMinX(cell.contentTitle.frame);
        cell.contentLocation.frame = textFrame;
        
        CGRect containerFrame = cell.contentLocation.frame;
        containerFrame.size.height = cell.contentLocation.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
        
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0|| [self.event.eventWhere isEqualToString:@"Unknown Location"])?1:0) + ((self.event.eventCalendarName.length > 0)?1:0)){
        //Calendar
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        cell.contentDescriptionLabel.text = TITLE_CALENDAR;
        cell.contentDescription.text = [NSString stringWithFormat:@"%@",self.event.eventCalendarName];
        tableCell = cell;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0|| [self.event.eventWhere isEqualToString:@"Unknown Location"])?1:0)+
              ((self.event.eventCalendarName.length > 0)?1:0) + ((self.event.eventCreatedBy.length > 0)?1:0)){
        //Created by
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        cell.contentDescriptionLabel.text = TITLE_CREATED_BY;
        cell.contentDescription.text = [NSString stringWithFormat:@"%@",self.event.eventCreatedBy];
        tableCell = cell;
    }else if (indexPath.row == 1 + ((self.event.eventWhere.length > 0|| [self.event.eventWhere isEqualToString:@"Unknown Location"])?1:0)+ ((self.event.eventCalendarName.length > 0)?1:0) + ((self.event.eventCreatedBy.length > 0)?1:0) + ((self.event.contentDescription.length > 0)?1:0)){
        //Description
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDescriptionTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDescriptionTableViewCell_ID];
        }
        cell.contentDescriptionLabel.text = TITLE_DESCRIPTION;
        [cell.contentDescription setText:[NSString stringWithFormat:@"%@",self.event.contentDescription]];
        
        [cell.contentDescription sizeToFit];
        CGRect textFrame = cell.contentDescription.frame;
        textFrame.size.width = WIDTH_CONTENT_CELL_DETAIL;
        cell.contentDescription.frame = textFrame;
        
        CGRect containerFrame = cell.contentDescription.frame;
        containerFrame.size.height = cell.contentDescription.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }
    
    return tableCell;
}

#pragma mark - Link google maps

- (void)clickedButtonLocation:(UIButton *)btnLocation{
    NSString *location = self.eventsLocation;
    NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%@",[location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Custom Methods

- (CGSize)getSizeTextView:(UITextView *)textView withText:(NSString *)text {
    textView.text = text;
    CGSize sizeResult = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    NSLog(@"tex = %@, he = %f",text,sizeResult.height);
    return sizeResult;
}


@end
