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
#import "EventNotificationTableViewCell.h"
#import "EventListModel.h"

@interface EventDetailViewController (){
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

- (NSString *)formatSummaryStringFromCommentObject:(NSString *)stringInput
{
    NSString *string = nil;
    NSMutableString *activityAndCommentString = [[NSMutableString alloc] init];
    if (stringInput.length != 0) {
        [activityAndCommentString appendFormat:@"%@", stringInput];
    }
    string = activityAndCommentString;
    return string;
}


#pragma mark - Table View Delegate - Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    if (indexPath.row == 0){
        EventDetailTableViewCell *cell = (EventDetailTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }else if (indexPath.row == 1){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 20;
    }else if (indexPath.row == 2){
        EventDetailMapTableViewCell *cell = (EventDetailMapTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + cell.contentTitle.frame.size.height;
    }else if (indexPath.row == 3){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }else if (indexPath.row == 4){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }else if (indexPath.row == 5){
        EventDescriptionTableViewCell *cell = (EventDescriptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height + 5;
    }
//    else if (indexPath.row == 6){
//        height = 45;
//    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    if (indexPath.row == 0){
        //Title
        EventDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailTableViewCell"];
        if (cell == nil) {
            cell = [[EventDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDetailTableViewCell"];
        }
        [cell.contentDetailEvents setText:self.eventsTitle];
        cell.contentDetailEvents.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [cell.contentDetailEvents sizeToFit];
        CGRect textFrame = cell.contentDetailEvents.frame;
        textFrame.size.width = 290;
        cell.contentDetailEvents.frame = textFrame;
        
        CGRect containerFrame = cell.contentDetailEvents.frame;
        containerFrame.size.height = cell.contentDetailEvents.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }else if (indexPath.row == 1){
        //Time
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailTableViewCell"];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDetailTableViewCell"];
        }
        
        cell.contentDescriptionLabel.text = @"Time";
        
        NSString *endReceivedInString = self.eventsEndTime;
        NSString *startReceivedInString = self.eventsStartTime;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS-HH:mm"];
//        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSDate *dateStringEnd= [dateFormatter dateFromString:endReceivedInString];
        NSDate *dateStringStart= [dateFormatter dateFromString:startReceivedInString];
        
        
//        cell.contentDetailEvents.text = [NSString stringWithFormat:@"Time: From %@ to %@",[startReceivedInString substringToIndex:16],[endReceivedInString substringToIndex:16]];

         cell.contentDescription.text = [NSString stringWithFormat:@"From %@ to %@",dateStringEnd ,dateStringStart];
        
        [cell.contentDescription sizeToFit];
        CGRect textFrame = cell.contentDescription.frame;
        textFrame.size.width = 240;
        cell.contentDescription.frame = textFrame;
        
        CGRect containerFrame = cell.contentDescription.frame;
        containerFrame.size.height = cell.contentDescription.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }else if (indexPath.row == 2){
        //Map
        EventDetailMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailMapTableViewCell"];
        if (cell == nil) {
            cell = [[EventDetailMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDetailMapTableViewCell"];
        }
        if (cell.contentLocation.text.length==0) {
            cell.contentLocation.text = [NSString stringWithFormat:@"%@",self.eventsLocation];
        }
        
        cell.contentTitle.text = @"Location";
        
        [cell.contentLocation sizeToFit];
        
        CGRect fMap = [cell.contentTitle frame];
        fMap.size.width = 280;
        [cell.contentTitle setFrame:fMap];
        
        CGRect textFrame = cell.contentLocation.frame;
        textFrame.size.width = 280;
        textFrame.origin.y = CGRectGetMinX(cell.contentTitle.frame);
        cell.contentLocation.frame = textFrame;
        
        CGRect containerFrame = cell.contentLocation.frame;
        containerFrame.size.height = cell.contentLocation.frame.size.height;
        cell.contentView.frame = containerFrame;
        
//        CGRect fMap = [cell.contentTitle frame];
//        fMap.origin.y = CGRectGetMinX(cell.contentLocation.frame);
//        [cell.contentTitle setFrame:fMap];
//        
//        CGRect textFrame = cell.contentLocation.frame;
//        textFrame.size.width = 280;
//        cell.contentLocation.frame = textFrame;
//        
//        CGRect containerFrame = cell.contentLocation.frame;
//        containerFrame.size.height = cell.contentLocation.frame.size.height;
//        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
        
    }else if (indexPath.row == 3){
        //Calendar
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailTableViewCell"];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDetailTableViewCell"];
        }
        cell.contentDescriptionLabel.text = @"Calendar";
        cell.contentDescription.text = [NSString stringWithFormat:@"%@",self.eventsCalendar];
        tableCell = cell;
    }else if (indexPath.row == 4){
        //Created by
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailTableViewCell"];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDetailTableViewCell"];
        }
        cell.contentDescriptionLabel.text = @"Created by ";
        cell.contentDescription.text = [NSString stringWithFormat:@"%@",self.eventsCreatedby];
        tableCell = cell;
    }else if (indexPath.row == 5){
        //Description
        EventDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDescriptionTableViewCell"];
        if (cell == nil) {
            cell = [[EventDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventDescriptionTableViewCell"];
        }
        cell.contentDescriptionLabel.text = @"Description";
        [cell.contentDescription setText:[NSString stringWithFormat:@"%@",self.eventsDescription]];
        
        [cell.contentDescription sizeToFit];
        CGRect textFrame = cell.contentDescription.frame;
        textFrame.size.width = 240;
        cell.contentDescription.frame = textFrame;
        
        CGRect containerFrame = cell.contentDescription.frame;
        containerFrame.size.height = cell.contentDescription.frame.size.height;
        cell.contentView.frame = containerFrame;
        
        tableCell = cell;
    }
//    else if (indexPath.row == 6){
//        //Notification
//        EventNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventNotificationTableViewCell"];
//        if (cell == nil) {
//            cell = [[EventNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventNotificationTableViewCell"];
//        }
//        cell.contentNotification.text = @"Notification: No notification set";
//        tableCell = cell;
//    }
    
    return tableCell;
}

#pragma mark - Custom Methods 

- (CGSize)getSizeTextView:(UITextView *)textView withText:(NSString *)text {
    textView.text = text;
    CGSize sizeResult = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    NSLog(@"tex = %@, he = %f",text,sizeResult.height);
    return sizeResult;
}


@end
