//
//  EventListModel.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventListModel.h"
#import "EAEventsDetails.h"
#import "AppDelegate.h"
#import "EventListTableViewCell.h"
#import "JSONLoader.h"

@implementation EventListModel{
    EAEventsDetails *eaEventsDetails;
    NSDictionary *dictEvents;
}

- (void)getJSONfile{
    NSData* data = [NSData dataWithContentsOfURL:ALL_EVENTS_LIST_URL_JSON];
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    //    [NSThread detachNewThreadSelector:@selector(insertData:) toTarget:self withObject:nil];
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    self.nameCalendar = JSON_NAME_CALENDAR;
    self.createdBy = JSON_CREATE_BY;
    self.arrayEvents = JSON_EVENTS_ARRAY;
    
    NSLog(@"json %@",json);
}



- (void)insertData:(NSArray *)arrayEvents{
    for (int i = 0; i < arrayEvents.count; i++) {
        eaEventsDetails = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:EAEVENTS_DETAILS_KEY inManagedObjectContext:EAManagedObjectContext];
        
        eaEventsDetails.eventCreatedBy = self.createdBy;
        eaEventsDetails.eventCalendarName = self.nameCalendar;
        
        eaEventsDetails.eventId = [[[arrayEvents objectAtIndex:i]valueForKey:ID_MAIN_KEY]valueForKey:DETAILS_KEY];
        eaEventsDetails.contentDescription = [[[arrayEvents objectAtIndex:i] valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY];
        eaEventsDetails.contentType = [[[arrayEvents objectAtIndex:i] valueForKey:CONTENT_MAIN_KEY]objectForKey:TYPE_MAIN_KEY];
        eaEventsDetails.titleName = [[[arrayEvents objectAtIndex:i] valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY];
        eaEventsDetails.titleType = [[[arrayEvents objectAtIndex:i] valueForKey:TITLE_MAIN_KEY]valueForKey:TYPE_MAIN_KEY];
        eaEventsDetails.linkRel = [[[[arrayEvents objectAtIndex:i] valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_REL_MAIN_KEY];
        eaEventsDetails.linkType = [[[[arrayEvents objectAtIndex:i] valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:TYPE_MAIN_KEY];
        eaEventsDetails.linkHref = [[[[arrayEvents objectAtIndex:i] valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_HREF_MAIN_KEY];
        eaEventsDetails.eventWhere = [[[[arrayEvents objectAtIndex:i] valueForKey:WHERE_MAIN_KEY]firstObject]valueForKey:VALUE_STRING_MAIN_KEY];

        NSString *endReceivedInString = [[[[arrayEvents objectAtIndex:i]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:END_TIME_MAIN_KEY];
        NSString *startReceivedInString =[[[[arrayEvents objectAtIndex:i]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:START_TIME_MAIN_KEY];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:FORMAT_DATE];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        eaEventsDetails.eventEndTime = [dateFormatter dateFromString:endReceivedInString];
        eaEventsDetails.eventStartTime = [dateFormatter dateFromString:startReceivedInString];
        
        NSLog(@"Done %@",eaEventsDetails);
        
        NSError *error;
        if (![EAManagedObjectContext save:&error]) {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
    }
}

- (NSArray *)arrayEvents{
    return _arrayEvents;
}

@end
