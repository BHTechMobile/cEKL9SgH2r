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
    NSMutableArray * dataJson = [NSMutableArray new];
    for (int i = 0; i < arrayEvents.count; i++) {
        
        NSString *endReceivedInString = [[[[arrayEvents objectAtIndex:i]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:END_TIME_MAIN_KEY];
        NSString *startReceivedInString =[[[[arrayEvents objectAtIndex:i]valueForKey:WHEN_MAIN_KEY]firstObject] valueForKey:START_TIME_MAIN_KEY];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if(endReceivedInString.length > LENGTH_SHORT_DATE_TIME){
            [dateFormatter setDateFormat:FORMAT_DATE];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            EAEventsDetails * eventDetail =
            [EAEventsDetails eventsDetailFromDictionary:@{
                                                          @"eventId":[[[arrayEvents objectAtIndex:i]valueForKey:ID_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          @"contentDescription":[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          @"contentType":[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          @"titleName":[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          @"titleType":[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          @"linkRel":[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_REL_MAIN_KEY],
                                                          @"linkType":[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:TYPE_MAIN_KEY],
                                                          @"linkHref":[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_HREF_MAIN_KEY],
                                                          @"eventWhere":[[[[arrayEvents objectAtIndex:i]valueForKey:WHERE_MAIN_KEY]firstObject]valueForKey:VALUE_STRING_MAIN_KEY],
                                                          @"eventCreatedBy":self.createdBy,
                                                          @"eventCalendarName":self.nameCalendar,
                                                          @"eventEndTime":[dateFormatter dateFromString:endReceivedInString],
                                                          @"eventStartTime":[dateFormatter dateFromString:startReceivedInString]
                                                          }];
            [dataJson addObject:eventDetail];
            
        }else{
            [dateFormatter setDateFormat:FORMAT_SHORT_DATE];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            EAEventsDetails * eventDetail =
            [EAEventsDetails eventsDetailFromDictionary:@{
                                                          @"eventId":[[[arrayEvents objectAtIndex:i]valueForKey:ID_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          @"contentDescription":[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          @"contentType":[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          @"titleName":[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          @"titleType":[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          @"linkRel":[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_REL_MAIN_KEY],
                                                          @"linkType":[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:TYPE_MAIN_KEY],
                                                          @"linkHref":[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_HREF_MAIN_KEY],
                                                          @"eventWhere":[[[[arrayEvents objectAtIndex:i]valueForKey:WHERE_MAIN_KEY]firstObject]valueForKey:VALUE_STRING_MAIN_KEY],
                                                          @"eventCreatedBy":self.createdBy,
                                                          @"eventCalendarName":self.nameCalendar,
                                                          @"eventEndTime":[dateFormatter dateFromString:endReceivedInString],
                                                          @"eventStartTime":[dateFormatter dateFromString:startReceivedInString]
                                                          }];
            [dataJson addObject:eventDetail];
            
        }
    }
    
    NSLog(@"Done %@",dataJson);
    NSError *error;
    if (![EAManagedObjectContext save:&error]) {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
}

- (NSArray *)arrayEvents{
    return _arrayEvents;
}

@end
