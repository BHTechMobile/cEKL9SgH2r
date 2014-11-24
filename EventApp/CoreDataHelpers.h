//
// CoreDataHelpers.h
//
#import <Foundation/Foundation.h>
#import "EAEventsDetails.h"

@interface CoreDataHelpers : NSObject

#pragma mark - General Methods
+ (void)wipeAllData:(NSError **)error;

#pragma mark - JTBodyPart
+ (NSArray *)alleventLists;
+ (NSArray *)eventListsWithIdContaining:(NSString *)eventId;
+ (NSArray *)alleventListsIds;
+ (EAEventsDetails *)eventListsById:(NSString *)eventId;
//+ (NSArray *)eventListsOfFront:(BOOL)front;

#pragma mark - Custom method
+ (BOOL)array:(NSArray *)inputArray differsFromArray:(NSArray *)sourceArray;

@end
