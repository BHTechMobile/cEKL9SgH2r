//
//  EventListModel.m
//  EventApp
//
//  Created by PhamHuuPhuong on 20/11/14.
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
    self.nameCalendar = [[[[[[json objectForKey:@"cids"]objectForKey:@"calendars%40startupdigest.com/private/embed"] objectForKey:@"gdata"] objectForKey:@"feed"]valueForKey:@"title"]valueForKey:@"$t"];
    
    self.createdBy = [[[[[[[[json objectForKey:@"cids"]objectForKey:@"calendars%40startupdigest.com/private/embed"] objectForKey:@"gdata"] objectForKey:@"feed"]valueForKey:@"author"]firstObject]valueForKey:@"name"]valueForKey:@"$t"];
    
    self.arrayEvents = [[[[[json objectForKey:@"cids"]objectForKey:@"calendars%40startupdigest.com/private/embed"] objectForKey:@"gdata"] objectForKey:@"feed"]valueForKey:@"entry"];
    
    NSLog(@"json %@",json);
}



- (void)insertData:(NSArray *)arrayEvents{
    for (int i = 0; i < arrayEvents.count; i++) {
        eaEventsDetails = (EAEventsDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"EAEventsDetails" inManagedObjectContext:EAManagedObjectContext];
        
        eaEventsDetails.eventCreatedBy = self.createdBy;
        eaEventsDetails.eventCalendarName = self.nameCalendar;
        
        eaEventsDetails.eventId = [[[arrayEvents objectAtIndex:i]valueForKey:@"id"]valueForKey:@"$t"];
        eaEventsDetails.contentDescription = [[[arrayEvents objectAtIndex:i] valueForKey:@"content"]valueForKey:@"$t"];
        eaEventsDetails.contentType = [[[arrayEvents objectAtIndex:i] valueForKey:@"content"]objectForKey:@"type"];
        eaEventsDetails.titleName = [[[arrayEvents objectAtIndex:i] valueForKey:@"title"]valueForKey:@"$t"];
        eaEventsDetails.titleType = [[[arrayEvents objectAtIndex:i] valueForKey:@"title"]valueForKey:@"type"];
        eaEventsDetails.linkRel = [[[[arrayEvents objectAtIndex:i] valueForKey:@"link"]firstObject]valueForKey:@"rel"];
        eaEventsDetails.linkType = [[[[arrayEvents objectAtIndex:i] valueForKey:@"link"]firstObject]valueForKey:@"type"];
        eaEventsDetails.linkHref = [[[[arrayEvents objectAtIndex:i] valueForKey:@"link"]firstObject]valueForKey:@"href"];
        eaEventsDetails.eventWhere = [[[[arrayEvents objectAtIndex:i] valueForKey:@"gd$where"]firstObject]valueForKey:@"valueString"];

        NSString *endReceivedInString = [[[[arrayEvents objectAtIndex:i]valueForKey:@"gd$when"]firstObject] valueForKey:@"endTime"];
        NSString *startReceivedInString =[[[[arrayEvents objectAtIndex:i]valueForKey:@"gd$when"]firstObject] valueForKey:@"startTime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS-HH:mm"];
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
