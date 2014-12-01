//
//  EventListModel.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventListModel : NSObject

@property (nonatomic, retain) NSArray *arrayEvents;
@property (nonatomic, retain) NSString *createdBy;
@property (nonatomic, retain) NSString *nameCalendar;

-(BOOL)isToday:(NSDate*)date;

- (void)getEventsSuccess:(void(^)())success failure:(void(^)(NSError* error))failure;
- (NSInteger)todayIndex;

+ (BOOL)isFuture:(NSDate*)date;

@end
