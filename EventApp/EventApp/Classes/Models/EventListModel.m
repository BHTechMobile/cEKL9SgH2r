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
#import "CoreDataHelpers.h"

@implementation EventListModel{
    EAEventsDetails *eaEventsDetails;
    NSDictionary *dictEvents;
}

-(id)init{
    self = [super init];
    if (self) {
        self.nameCalendar = @"Silicon Valley StartupDigest";
        self.createdBy = @"startupdigest.com";

    }
    return self;
}

- (void)getEventsSuccess:(void(^)())success failure:(void(^)(NSError* error))failure{
    [JSONLoader requestDataSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self insertData:[[responseObject valueForKey:@"feed"] valueForKey:@"entry"]];
            if (success) {
                success();
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#define SeperateArrayString @"----"
#define NewYearString @"Wed Jan 1, 2014 0am"

-(void)breakString:(NSString*)inputString toStartTime:(NSDate**)startTime andEndTime:(NSDate**)endTime location:(NSString**)location timeZone:(NSString**)timeZone{
    NSString * startTimeString = @"";
    NSString * endTimeString = @"";
    BOOL hasStartTime = YES;
    BOOL hasEndTime = YES;
    BOOL hasGMT = YES;
    BOOL hasLocation = YES;
    BOOL hasStatus = YES;
    
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    hasStartTime    = !([inputString rangeOfString:@"When: "].location == NSNotFound);
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"When: " withString:@""];
    
    hasEndTime      = !([inputString rangeOfString:@" to "].location == NSNotFound);
    inputString     = [inputString stringByReplacingOccurrencesOfString:@" to " withString:SeperateArrayString];
    
    hasGMT          = !([inputString rangeOfString:@"GMT"].location == NSNotFound);
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"GMT" withString:SeperateArrayString];
    
    hasLocation     = !([inputString rangeOfString:@"Where: "].location == NSNotFound);
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"Where: " withString:SeperateArrayString];
    
    hasStatus       = !([inputString rangeOfString:@"Event Status: "].location == NSNotFound);
    inputString     = [inputString stringByReplacingOccurrencesOfString:@"Event Status: " withString:SeperateArrayString];
    
    NSArray * resultArray = [inputString componentsSeparatedByString:SeperateArrayString];
    @try {
        startTimeString = hasStartTime?resultArray[0]:@"Unknown Date";
        endTimeString = hasEndTime?resultArray[hasStartTime]:@"Unknown Date";
        if ([endTimeString isEqualToString:@"Unknown Date"]) {
            
        }
        *timeZone = hasGMT?resultArray[hasStartTime+hasEndTime]:@"0";
        *location = hasLocation?resultArray[hasStartTime+hasEndTime+hasLocation]:@"Unknown Location";
        //        * = hasStatus?resultArray[hasStartTime+hasEndTime+hasGMT+hasLocation];
        
        NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];

        
        [startDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(NSInteger)((*timeZone).floatValue*3600)]];
        [endDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(NSInteger)((*timeZone).floatValue*3600)]];

        if (!([startTimeString rangeOfString:@":"].location == NSNotFound)) {
            [startDateFormatter setDateFormat:FORMAT_DATE];
        }
        else if (startTimeString.length >16){
            [startDateFormatter setDateFormat:FORMAT_DATE_NO_MINUTE];
        }
        else{
            [startDateFormatter setDateFormat:FORMAT_DATE_ALL_DAY];
            [endDateFormatter setDateFormat:FORMAT_DATE_ALL_DAY];
            endTimeString = startTimeString;
        }
        
        if (endTimeString.length <10) {
            NSString * checkPoint = [startTimeString substringWithRange:NSMakeRange(15, 1)];
            endTimeString = [[startTimeString substringToIndex:[checkPoint isEqualToString:@" "]?15:16] stringByAppendingString:[NSString stringWithFormat:@" %@",endTimeString]];
        }
        
        if (!([endTimeString rangeOfString:@":"].location == NSNotFound)) {
            [endDateFormatter setDateFormat:FORMAT_DATE];
        }
        else if (endTimeString.length >16){
            [endDateFormatter setDateFormat:FORMAT_DATE_NO_MINUTE];
        }
        
        *startTime = [startDateFormatter dateFromString:startTimeString];
        *endTime = [endDateFormatter dateFromString:endTimeString];
        
        if (!(*startTime)) {
            NSLog(@"%@",startTimeString);
        }
        
        if (!(*endTime)) {
            NSLog(@"%@",endTimeString);
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    
}

-(NSString*)descriptionFromContent:(NSString*)content{
    NSString * resultString = @"";
    @try {
        content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        content = [content stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"<br />" withString:@""];

        NSArray *contents = [content componentsSeparatedByString:@"Event Description: "];
        if (contents.count >1) {
            resultString = contents[1];
        }
        else{
            resultString = content;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return resultString;
    }
}

- (void)insertData:(NSArray *)arrayEvents{
    NSMutableArray * events = [NSMutableArray new];
    for (int i = 0; i < arrayEvents.count; i++) {
        
        NSDictionary * dic = arrayEvents[i];
        NSDate* startDate;
        NSDate* endDate;

        NSString* locationString = @"";
        NSString* timeZoneString = @"";
        
        [self breakString:[[dic valueForKey:SUMMARY_KEY] valueForKey:DETAILS_KEY] toStartTime:&startDate andEndTime:&endDate location:&locationString timeZone:&timeZoneString];
        if ([locationString isEqualToString:@"Unknow Location"]) {
            NSLog(@"%@",[[dic valueForKey:TITLE_MAIN_KEY] valueForKey:DETAILS_KEY]);
        }
        
        EAEventsDetails* eventDetail = [EAEventsDetails eventsDetailFromDictionary:@{
                                                                                     @"eventId":[[[arrayEvents objectAtIndex:i] valueForKey:ID_MAIN_KEY] valueForKey:DETAILS_KEY],
                                                                                     @"contentDescription":[self descriptionFromContent:[[dic valueForKey:CONTENT_MAIN_KEY]valueForKey:DETAILS_KEY]],
                                                                                     @"contentType":[[dic valueForKey:CONTENT_MAIN_KEY] valueForKey:TYPE_MAIN_KEY],
                                                                                     @"titleName":[[dic valueForKey:TITLE_MAIN_KEY] valueForKey:DETAILS_KEY],
                                                                                     @"titleType":[[dic valueForKey:TITLE_MAIN_KEY] valueForKey:TYPE_MAIN_KEY],
                                                                                     @"linkRel":[[[dic valueForKey:LINK_MAIN_KEY] firstObject]valueForKey:LINK_REL_MAIN_KEY],
                                                                                     @"linkType":[[[dic valueForKey:LINK_MAIN_KEY] firstObject]valueForKey:TYPE_MAIN_KEY],
                                                                                     @"linkHref":[[[dic valueForKey:LINK_MAIN_KEY] firstObject]valueForKey:LINK_HREF_MAIN_KEY],
                                                                                     @"eventWhere":locationString,
                                                                                     @"eventCreatedBy":self.createdBy,
                                                                                     @"eventCalendarName":self.nameCalendar,
                                                                                     @"eventEndTime":endDate,
                                                                                     @"eventStartTime":startDate
                                                                                     }];
        [events addObject:eventDetail];
    }
    
    NSError *error = nil;
    if (![EAManagedObjectContext save:&error]) {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
}

- (NSArray *)arrayEvents{
    return [CoreDataHelpers allEvents];
}

@end
