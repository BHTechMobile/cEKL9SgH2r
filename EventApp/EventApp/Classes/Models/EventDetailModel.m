//
//  EventDetailModel.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventDetailModel.h"

@implementation EventDetailModel

-(void)saveEventToCalendar{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (![_event.eventStoreId isEqualToString:@""]) {
                    EKEvent* eventToRemove = [store eventWithIdentifier:_event.eventStoreId];
                    if (eventToRemove) {
                        NSError* error = nil;
                        [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
                    }
                }
            
                EKEvent *event = [EKEvent eventWithEventStore:store];
                event.title = _event.titleName;
                event.startDate = _event.eventStartTime;
                event.endDate = _event.eventEndTime;
                [event setCalendar:[store defaultCalendarForNewEvents]];
                NSError *err = nil;
                [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                _event.eventStoreId = event.eventIdentifier;
                [self showMessage:@"Event Added!"];
            }
            else // if does not allow
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calendar Access Denied"
                                                                message:@"Please enable access in Privacy Settings to use this feature."
                                                               delegate:self
                                                      cancelButtonTitle:@"Setting"
                                                      otherButtonTitles:@"Cancel", nil];
                alert.tag = myAlertViewsTag;
                [alert show];
            }
        });
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == myAlertViewsTag && buttonIndex == 0)
    {
       [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
-(void)showMessage:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    });
}

@end
