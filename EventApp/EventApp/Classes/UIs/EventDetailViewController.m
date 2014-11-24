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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
    
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

#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = HEIGHT_CELL_DETAIL_EVENT;
    if (indexPath.row == 0){
        EventDetailTableViewCell *cell = (EventDetailTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT_;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)){
        EventDetailMapTableViewCell *cell = (EventDetailMapTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + cell.contentTitle.frame.size.height;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0) + ((self.eventsCreatedby.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0) + ((self.eventsCreatedby.length > 0)?1:0) + ((self.eventsDescription.length > 0)?1:0)){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + SPACE_HEIGHT_CELL_DETAIL_EVENT;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0) + ((self.eventsCreatedby.length > 0)?1:0) + ((self.eventsDescription.length > 0)?1:0) ;
}

+ (NSString *)dateStringFromString:(NSString *)sourceString
                      sourceFormat:(NSString *)sourceFormat
                 destinationFormat:(NSString *)destinationFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:sourceFormat];
    NSDate *date = [dateFormatter dateFromString:sourceString];
    [dateFormatter setDateFormat:destinationFormat];
    return [dateFormatter stringFromDate:date];
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
        [cell.contentDetailEvents setText:self.eventsTitle];
        cell.contentDetailEvents.font = [UIFont fontWithName:FONT_HELVETICA_BOLD size:14];
        [cell.contentDetailEvents sizeToFit];
        CGRect textFrame = cell.contentDetailEvents.frame;
        textFrame.size.width = WIDTH_TITLE_CELL_DETAIL;
        cell.contentDetailEvents.frame = textFrame;
        
        CGRect containerFrame = cell.contentDetailEvents.frame;
        containerFrame.size.height = cell.contentDetailEvents.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0)){
        //Time
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        
        cell.contentDescriptionLabel.text = TITLE_TIME;
        
        NSString *startReceivedInString = self.eventsStartTime;
        NSString *endReceivedInString = self.eventsEndTime;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if(self.eventsStartTime.length > LENGTH_SHORT_DATE_TIME){
            [formatter setDateFormat:FORMAT_DATE];
            NSDate *dt = [formatter dateFromString:endReceivedInString];
            NSDate *dt2 = [formatter dateFromString:startReceivedInString];
            
            [formatter setDateStyle:NSDateFormatterFullStyle];
            NSString *dateAsStringEnd = [formatter stringFromDate:dt];
            NSString *dateAsStringStart = [formatter stringFromDate:dt2];
            
            cell.contentDescription.text = [NSString stringWithFormat:@"From %@ \n to %@",dateAsStringStart ,dateAsStringEnd];
        }
        else{
            [formatter setDateFormat:FORMAT_SHORT_DATE];
            NSDate *dt = [formatter dateFromString:[endReceivedInString substringToIndex:LENGTH_SHORT_DATE_TIME]];
            NSDate *dt2 = [formatter dateFromString:[startReceivedInString substringToIndex:LENGTH_SHORT_DATE_TIME]];
            
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            NSString *dateAsStringEnd = [formatter stringFromDate:dt];
            NSString *dateAsStringStart = [formatter stringFromDate:dt2];
            
            cell.contentDescription.text = [NSString stringWithFormat:@"From %@ to %@",dateAsStringStart ,dateAsStringEnd];
        }

        [cell.contentDescription sizeToFit];
        CGRect textFrame = cell.contentDescription.frame;
        textFrame.size.width = WIDTH_CONTENT_CELL_DETAIL;
        cell.contentDescription.frame = textFrame;
        
        CGRect containerFrame = cell.contentDescription.frame;
        containerFrame.size.height = cell.contentDescription.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)){
        //Map
        EventDetailMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailMapTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDetailMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailMapTableViewCell_ID];
        }
        if (cell.contentLocation.text.length==0) {
            cell.contentLocation.text = [NSString stringWithFormat:@"%@",self.eventsLocation];
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
        
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0)){
        //Calendar
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        cell.contentDescriptionLabel.text = TITLE_CALENDAR;
        cell.contentDescription.text = [NSString stringWithFormat:@"%@",self.eventsCalendar];
        tableCell = cell;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0) + ((self.eventsCreatedby.length > 0)?1:0)){
        //Created by
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDetailTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDetailTableViewCell_ID];
        }
        cell.contentDescriptionLabel.text = TITLE_CREATED_BY;
        cell.contentDescription.text = [NSString stringWithFormat:@"%@",self.eventsCreatedby];
        tableCell = cell;
    }else if (indexPath.row == ((self.eventsStartTime.length > 0)?1:0) + ((self.eventsLocation.length > 0)?1:0)+ ((self.eventsCalendar.length > 0)?1:0) + ((self.eventsCreatedby.length > 0)?1:0) + ((self.eventsDescription.length > 0)?1:0)){
        //Description
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventDescriptionTableViewCell_ID];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventDescriptionTableViewCell_ID];
        }
        cell.contentDescriptionLabel.text = TITLE_DESCRIPTION;
        [cell.contentDescription setText:[NSString stringWithFormat:@"%@",self.eventsDescription]];
        
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
//    [self performSegueWithIdentifier:SEGUE_INDENTIFIER_MAP_VIEW sender:nil];
//    MapViewController *mapViewController = [[MapViewController alloc] init];
//    
//    [mapViewController.mapContentView loadRequest:[NSURLRequest requestWithURL:
//                            [NSURL URLWithString: @"http://www.google.com"]]];
    
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
