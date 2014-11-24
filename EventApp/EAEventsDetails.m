//
//  EAEventsDetails.m
//  EventApp
//
//  Created by PhamHuuPhuong on 20/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EAEventsDetails.h"


@implementation EAEventsDetails

@dynamic titleType;
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

+ (EAEventsDetails *)eventListsFromDictionary:(NSDictionary *)dict {
    EAEventsDetails *managedObject = (EAEventsDetails *)[EAEventsDetails managedObjectWithKey:EAEVENTLIST_KEY_NAME andValue:[dict valueForKey:EAEVENTLIST_KEY_NAME]];
    
    if (managedObject == nil) {
        managedObject = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:[EAEventsDetails description] inManagedObjectContext:EAManagedObjectContext];
    }
    
    [managedObject updateFromDict:dict];
    return managedObject;
}

+ (EAEventsDetails *)eventLists {
    EAEventsDetails *bodyPart = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:[EAEventsDetails description] inManagedObjectContext:EAManagedObjectContext];
    
    return bodyPart;
}

+ (EAEventsDetails *)eventListsByName:(NSString *)name {
    return (EAEventsDetails *)[EAEventsDetails managedObjectWithKey:EAEVENTLIST_KEY_NAME andValue:name];
}


@end
