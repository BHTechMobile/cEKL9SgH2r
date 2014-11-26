//
//  EAEventsDetails.h
//  EventApp
//
//  Created by PhamHuuPhuong on 20/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+Utilities.h"

@interface EAEventsDetails : NSManagedObject

@property (nonatomic, retain) NSString * eventStoreId;
@property (nonatomic, retain) NSString * titleName;
@property (nonatomic, retain) NSString * linkType;
@property (nonatomic, retain) NSString * linkRel;
@property (nonatomic, retain) NSString * linkHref;
@property (nonatomic, retain) NSString * eventWhere;
@property (nonatomic, retain) NSString * eventStatus;
@property (nonatomic, retain) NSDate * eventStartTime;
@property (nonatomic, retain) NSNumber * eventNotification;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSDate * eventEndTime;
@property (nonatomic, retain) NSString * contentType;
@property (nonatomic, retain) NSString * contentDescription;
@property (nonatomic, retain) NSString * eventCalendarName;
@property (nonatomic, retain) NSString * eventCreatedBy;
@end

@interface EAEventsDetails (CoreDataGeneratedAccessors)

- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

+ (EAEventsDetails *)eventsDetailFromDictionary:(NSDictionary *)dict;
+ (EAEventsDetails *)eventsDetail;
+ (EAEventsDetails *)eventsDetailByID:(NSString *)eventID;

@end
