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
                                                          EA_KEY_ID:[[[arrayEvents objectAtIndex:i]valueForKey:ID_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          EA_KEY_CONTENT_DESCRIPTION:[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          EA_KEY_CONTENT_TYPE:[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          EA_KEY_TITLE_NAME:[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          EA_KEY_TITLE_TYPE:[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          EA_KEY_LINK_REL:[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_REL_MAIN_KEY],
                                                          EA_KEY_LINK_TYPE:[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:TYPE_MAIN_KEY],
                                                          EA_KEY_LINK_HREF:[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_HREF_MAIN_KEY],
                                                          EA_KEY_EVENT_WHERE:[[[[arrayEvents objectAtIndex:i]valueForKey:WHERE_MAIN_KEY]firstObject]valueForKey:VALUE_STRING_MAIN_KEY],
                                                          EA_KEY_EVENT_CREATED_BY:self.createdBy,
                                                          EA_KEY_EVENT_CALENDAR_NAME:self.nameCalendar,
                                                          EA_KEY_EVENT_END_TIME:[dateFormatter dateFromString:endReceivedInString],
                                                          EA_KEY_EVENT_START_TIME:[dateFormatter dateFromString:startReceivedInString]
                                                          }];
            [dataJson addObject:eventDetail];
            
        }else{
            [dateFormatter setDateFormat:FORMAT_SHORT_DATE];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            EAEventsDetails * eventDetail =
            [EAEventsDetails eventsDetailFromDictionary:@{
                                                          EA_KEY_ID:[[[arrayEvents objectAtIndex:i]valueForKey:ID_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          EA_KEY_CONTENT_DESCRIPTION:[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          EA_KEY_CONTENT_TYPE:[[[arrayEvents objectAtIndex:i]valueForKey:CONTENT_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          EA_KEY_TITLE_NAME:[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:DETAILS_KEY],
                                                          EA_KEY_TITLE_TYPE:[[[arrayEvents objectAtIndex:i]valueForKey:TITLE_MAIN_KEY]valueForKey:TYPE_MAIN_KEY],
                                                          EA_KEY_LINK_REL:[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_REL_MAIN_KEY],
                                                          EA_KEY_LINK_TYPE:[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:TYPE_MAIN_KEY],
                                                          EA_KEY_LINK_HREF:[[[[arrayEvents objectAtIndex:i]valueForKey:LINK_MAIN_KEY]firstObject]valueForKey:LINK_HREF_MAIN_KEY],
                                                          EA_KEY_EVENT_WHERE:[[[[arrayEvents objectAtIndex:i]valueForKey:WHERE_MAIN_KEY]firstObject]valueForKey:VALUE_STRING_MAIN_KEY],
                                                          EA_KEY_EVENT_CREATED_BY:self.createdBy,
                                                          EA_KEY_EVENT_CALENDAR_NAME:self.nameCalendar,
                                                          EA_KEY_EVENT_END_TIME:[dateFormatter dateFromString:endReceivedInString],
                                                          EA_KEY_EVENT_START_TIME:[dateFormatter dateFromString:startReceivedInString]
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
