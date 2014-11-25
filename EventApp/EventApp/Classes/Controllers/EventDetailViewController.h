//
//  EventDetailViewController.h
//  EventApp
//
//  Created by Tommy on 11/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAEventsDetails.h"

@interface EventDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) EAEventsDetails *event;

@property (strong, nonatomic) NSString *eventsTitle;
@property (strong, nonatomic) NSString *eventsEndTime;
@property (strong, nonatomic) NSString *eventsStartTime;
@property (strong, nonatomic) NSString *eventsLocation;
@property (strong, nonatomic) NSString *eventsCalendar;
@property (strong, nonatomic) NSString *eventsCreatedby;
@property (strong, nonatomic) NSString *eventsDescription;

@end
