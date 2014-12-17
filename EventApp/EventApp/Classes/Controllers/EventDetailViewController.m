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
#import "EventShareFacebookTableViewCell.h"
#import "EventListModel.h"
#import <MapKit/MapKit.h>
#import "EventDetailModel.h"

@interface EventDetailViewController ()<EventDetailMapTableViewCellDelegate,EventShareFacebookTableViewCellDelegate,UITextViewDelegate>{
    EventListModel *eventListModel;
    NSURL *linktoWeb;
}

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    eventListModel = [EventListModel new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.title = self.event.titleName;
    UIImage *backImage = [UIImage imageNamed:@"btn_back_cyan"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 15, 20)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
}

- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(EAEventsDetails*)event{
    return _eventDetailModel.event;
}

-(void)setEvent:(EAEventsDetails *)event{
    _eventDetailModel = [[EventDetailModel alloc] init];
    _eventDetailModel.event = event;
}

- (IBAction)addEvent:(id)sender {
    [_eventDetailModel saveEventToCalendar];
}

#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = HEIGHT_CELL_DETAIL_EVENT;
    if (indexPath.row == INDEX_PATH_ROW){
        EventDetailTableViewCell *cell = (EventDetailTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT;
    }
    else if (indexPath.row == INDEX_PATH_ROW_){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT_;
    }
    else if (indexPath.row == INDEX_PATH_ROW_ + ((self.event.eventWhere.length > 0)?1:0)){
        EventDetailMapTableViewCell *cell = (EventDetailMapTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + cell.contentTitle.frame.size.height;
    }
    else if (indexPath.row == INDEX_PATH_ROW_ + ((self.event.eventWhere.length > 0)?1:0)+ ((self.event.contentDescription.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT_;
    }
    else{
        EventShareFacebookTableViewCell *cell = (EventShareFacebookTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT_;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return INDEX_PATH_ROW__ + ((self.event.eventWhere.length > 0)?1:0)+ ((self.event.contentDescription.length > 0)?1:0) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    if (indexPath.row == INDEX_PATH_ROW){
        //Title
        EventDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        [cell.contentDetailEvents setText:self.event.titleName];
        cell.contentDetailEvents.font = [UIFont fontWithName:FONT_HELVETICA_BOLD size:14];
        [cell.contentDetailEvents sizeToFit];
        CGRect textFrame = cell.contentDetailEvents.frame;
        textFrame.size.width = WIDTH_TITLE_CELL_DETAIL;
        cell.contentDetailEvents.frame = textFrame;
        
        CGRect containerFrame = cell.contentDetailEvents.frame;
        containerFrame.size.height = cell.contentDetailEvents.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }
    else if (indexPath.row == INDEX_PATH_ROW_){
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
        
        cell.contentDescription.text = [NSString stringWithFormat:FROM_TO,dateAsStringStart ,dateAsStringEnd];
        
        [cell.contentDescription sizeToFit];
        CGRect textFrame = cell.contentDescription.frame;
        textFrame.size.width = WIDTH_CONTENT_CELL_DETAIL;
        cell.contentDescription.frame = textFrame;
        
        CGRect containerFrame = cell.contentDescription.frame;
        containerFrame.size.height = cell.contentDescription.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }
    else if (indexPath.row == INDEX_PATH_ROW_ + ((self.event.eventWhere.length > 0)?1:0)){
        //Map
        EventDetailMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailMapTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDetailMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailMapTableViewCell_ID];
        }
        if (cell.contentLocation.text.length==0) {
            cell.contentLocation.text = [NSString stringWithFormat:@"%@",self.event.eventWhere];
        }
        
        if ([self.event.eventWhere isEqualToString:UNKNOWN_LOCATION]) {
            cell.mapButton.hidden = YES;
        }else{
            cell.mapButton.hidden = NO;
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
        
    }
    else if (indexPath.row == INDEX_PATH_ROW_ + ((self.event.eventWhere.length > 0)?1:0) + ((self.event.contentDescription.length > 0)?1:0)){
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
        [cell.contentDescription setDelegate:self];
        tableCell = cell;
    }
    else{
        EventShareFacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventShareFacebookTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventShareFacebookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventShareFacebookTableViewCell_ID];
        }
        [cell setDelegate:self];
        [cell.sharefbButton setTag:indexPath.row];
        CGRect textFrame = cell.sharefbButton.frame;
        textFrame.size.width = WIDTH_TITLE_CELL_DETAIL;
        cell.sharefbButton.frame = textFrame;
        
        CGRect containerFrame = cell.sharefbButton.frame;
        containerFrame.size.height = cell.sharefbButton.frame.size.height;
        cell.contentView.frame = containerFrame;
        tableCell = cell;
    }
    return tableCell;
}

#pragma mark - Link google maps

- (void)clickedButtonLocation:(UIButton *)btnLocation{
    
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:QS_MAP_TITLE
                                                           message:QS_MAP
                                                          delegate:self
                                                 cancelButtonTitle:NO_KEY
                                                 otherButtonTitles:YES_KEY,nil];
    [messageAlert setTag:AlertLinkMap];
    [messageAlert show];
}

#pragma mark - button shareFB

- (void)clickedButtonShareFb:(UIButton *)btnShareFb{
    [_eventDetailModel shareFacebookButton];
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case AlertLinkMap:{
            if (buttonIndex == 1)
            {
                NSString *location = self.event.eventWhere;
                NSString *url = [NSString stringWithFormat: @"http://maps.apple.com/?q=%@",[location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else if (buttonIndex == 0){
                NSLog(@"NO");
            }
        }
            break;
        case AlertLinkWeb:{
            if (buttonIndex == 1)
            {
                [[UIApplication sharedApplication] openURL:linktoWeb];
            }else if (buttonIndex == 0){
                NSLog(@"NO");
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    linktoWeb = URL;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:QS_WEB_TITLE
                                                        message:QS_WEB
                                                       delegate:self
                                              cancelButtonTitle:NO_KEY
                                              otherButtonTitles:YES_KEY,nil];
    [alertView setTag:AlertLinkWeb];
    [alertView show];
    
    return NO;
}


#pragma mark - Custom Methods

- (CGSize)getSizeTextView:(UITextView *)textView withText:(NSString *)text {
    textView.text = text;
    CGSize sizeResult = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    NSLog(@"tex = %@, he = %f",text,sizeResult.height);
    return sizeResult;
}


@end
