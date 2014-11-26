//
//  EventDetailModel.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "EAEventsDetails.h"

@interface EventDetailModel : NSObject

@property (nonatomic,strong) EAEventsDetails* event;

-(void)saveEventToCalendar;

@end
