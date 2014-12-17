//
//  EventDetailModel.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventDetailModel.h"
#import <Social/Social.h>

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
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calendar Access Denied"
                                                                    message:@"Please enable access in Privacy Settings to use this feature."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Setting"
                                                          otherButtonTitles:@"Cancel", nil];
                    
                    alert.tag = TAG_ALERT_SHOW_IOS_8;
                    [alert show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calendar Access Denied"
                                                                    message:@"Please enable access in Privacy>Calendar to use this feature."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    alert.tag = TAG_ALERT_SHOW_IOS_7;
                    [alert show];
                }
            }
        });
    }];
}

- (void)shareFacebookButton{
    NSString *title = self.event.titleName;
    NSDate *startTime = self.event.eventStartTime;
    NSDate *endTime = self.event.eventEndTime;
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:FORMAT_DATE];
    
    [dataFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dataFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateAsStringEnd = [dataFormatter stringFromDate:endTime];
    NSString *dateAsStringStart = [dataFormatter stringFromDate:startTime];
    NSString *location = self.event.eventWhere;
    NSString *message =[NSString
                        stringWithFormat:@"Event Title: %@.\n Start-Time: %@.\n End-Time: %@.\n Location: %@. "
                        ,title,dateAsStringStart,dateAsStringEnd,location];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:message];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not post on your wall" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    NSLog(@"Post Canceled");
                    break;
                }
                case SLComposeViewControllerResultDone:{
                    NSLog(@"Post Sucessful");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Posted succesfully on your wall" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
        UIViewController *activeController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([activeController isKindOfClass:[UINavigationController class]]) {
            activeController = [(UINavigationController*) activeController visibleViewController];
        }
            [activeController presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook Account"
                                                            message:@"There are no Facebook account configured.You can add or create a Facebook account in Settings."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil, nil];
            
        alert.tag = TAG_ALERT_SHOW_FACEBOOK;
        [alert show];
    }
}
#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERT_SHOW_IOS_8 && buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark-Show Messages

-(void)showMessage:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    });
}

@end
