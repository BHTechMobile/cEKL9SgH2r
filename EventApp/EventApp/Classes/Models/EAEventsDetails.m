//
//  EAEventsDetails.m
//  EventApp
//
//  Created by PhamHuuPhuong on 20/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EAEventsDetails.h"


@implementation EAEventsDetails

@dynamic eventStoreId;
@dynamic titleName;
@dynamic linkType;
@dynamic linkRel;
@dynamic linkHref;
@dynamic eventWhere;
@dynamic eventStatus;
@dynamic eventStartTime;
@dynamic eventNotification;
@dynamic eventId;
@dynamic eventEndTime;
@dynamic contentType;
@dynamic contentDescription;
@dynamic eventCalendarName;
@dynamic eventCreatedBy;

+ (EAEventsDetails *)eventsDetailFromDictionary:(NSDictionary *)dict {
    EAEventsDetails *managedObject = (EAEventsDetails *)[EAEventsDetails managedObjectWithKey:EAEVENTLIST_KEY_ID andValue:[dict valueForKey:EAEVENTLIST_KEY_ID]];
    
    NSString * currentStoreId = @"";
    
    if (managedObject == nil) {
        managedObject = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:[EAEventsDetails description] inManagedObjectContext:EAManagedObjectContext];
    }
    else{
        currentStoreId = managedObject.eventStoreId;
    }
    
    if (currentStoreId && ![currentStoreId isEqualToString:@""]) {
        managedObject.eventStoreId = currentStoreId;
    }
    
    [managedObject updateFromDict:dict];
    return managedObject;
}

+ (EAEventsDetails *)eventsDetail {
    EAEventsDetails *eventDetail = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:[EAEventsDetails description] inManagedObjectContext:EAManagedObjectContext];
    
    return eventDetail;
}

+ (EAEventsDetails *)eventsDetailByID:(NSString *)eventID {
    return (EAEventsDetails *)[EAEventsDetails managedObjectWithKey:EAEVENTLIST_KEY_ID andValue:eventID];
}


@end
