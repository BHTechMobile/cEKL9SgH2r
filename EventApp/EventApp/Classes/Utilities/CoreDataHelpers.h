//
// CoreDataHelpers.h
//
#import <Foundation/Foundation.h>
#import "EAEventsDetails.h"

@interface CoreDataHelpers : NSObject

#pragma mark - General Methods
+ (void)wipeAllData:(NSError **)error;

#pragma mark - Events
+ (NSArray *)allEvents;
+ (NSArray *)eventsWithIdContaining:(NSString *)eventId;
+ (EAEventsDetails *)eventById:(NSString *)eventId;

#pragma mark - Custom method
+ (BOOL)array:(NSArray *)inputArray differsFromArray:(NSArray *)sourceArray;

@end
