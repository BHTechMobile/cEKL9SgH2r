//
//  CoreDataHelpers.m
//

#import "CoreDataHelpers.h"
#import "EAEventsDetails.h"
#import "EventListModel.h"

@implementation CoreDataHelpers

#pragma mark - General Methods

+ (NSArray *)allManageObjectsInEntity:(NSString *)entityName withKey:(NSString *)key condition:(NSString *)condition value:(NSString *)value orderBy:(NSString *)orderKey {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
	if (value) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ %@ '%@'", key, condition, value]];
		[fetchRequest setPredicate:predicate];
	}
    
	if (orderKey) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:orderKey ascending:YES];
		NSArray *sortDescriptors = @[sortDescriptor];
		[fetchRequest setSortDescriptors:sortDescriptors];
	}
    
	NSError *error = nil;
	NSArray *managedObjects = [EAManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
	if (error) {
		LogError(error);
		managedObjects = nil;
	}
    
	return managedObjects;
}

+ (NSArray *)allValueOfKey:(NSString *)key inEntity:(NSString *)entityName orderBy:(NSString *)orderKey {
	NSArray *managedObjects = [CoreDataHelpers allManageObjectsInEntity:entityName withKey:nil condition:nil value:nil orderBy:orderKey];
	NSMutableArray *valueArray = nil;
    
	if (managedObjects != nil) {
		valueArray = [NSMutableArray array];
        
		for (NSManagedObject *object in managedObjects) {
			if ([object valueForKey:key]) {
				[valueArray addObject:[object valueForKey:key]];
			}
		}
	}
    
	return valueArray;
}

+ (NSArray *)allMangedObjectInEntity:(NSString *)entityName orderBy:(NSString *)orderKey {
	NSArray *managedObjects = [CoreDataHelpers allManageObjectsInEntity:entityName withKey:nil condition:nil value:nil orderBy:orderKey];
    
	return managedObjects;
}

+ (NSArray *)allManageObjectsInEntity:(NSString *)entityName withKey:(NSString *)key contain:(NSString *)value orderBy:(NSString *)orderKey {
	NSArray *managedObjects = [CoreDataHelpers allManageObjectsInEntity:entityName withKey:key condition:CONDITION_CONTAINS value:value orderBy:orderKey];
    
	return managedObjects;
}

+ (NSManagedObject *)manageObjectInEntity:(NSString *)entityName withKey:(NSString *)key andValue:(NSString *)value {
	NSArray *managedObjects = [CoreDataHelpers allManageObjectsInEntity:entityName withKey:key condition:CONDITION_EQUAL value:value orderBy:nil];
	NSManagedObject *managedObject = nil;
    
	if (managedObjects != nil) {
		managedObject = [managedObjects firstObject];
	}
    
	return managedObject;
}

+ (void)wipeAllData:(NSError **)error {
	NSArray *entities = EAManagedObjectModel.entities;
	for (id entity in entities) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		NSArray *items = [EAManagedObjectContext executeFetchRequest:fetchRequest error:error];

		for (NSManagedObject *managedObject in items) {
			[EAManagedObjectContext deleteObject:managedObject];
			NSLog(@"%@ object deleted", [entity name]);
		}
	}
}

#pragma mark - EAEventsDetails

+ (NSArray *)allEvents {
    NSArray * coreDataResult = [CoreDataHelpers allMangedObjectInEntity:[EAEventsDetails description] orderBy:@"eventStartTime"];
    NSMutableArray* result = [NSMutableArray new];
    for (int i = 0; i<coreDataResult.count; ++i) {
        
        if ([EventListModel isFuture:((EAEventsDetails*)coreDataResult[i]).eventStartTime]){
            [result addObject:coreDataResult[i]];
        }
        else if ([EventListModel isFuture:((EAEventsDetails*)coreDataResult[i]).eventEndTime]) {
            [result addObject:coreDataResult[i]];
        }
      
    }
	return result;
}

+ (NSArray *)eventsWithIdContaining:(NSString *)eventId {
	return [CoreDataHelpers allManageObjectsInEntity:[EAEventsDetails description] withKey:EAKey_Id contain:eventId orderBy:EAKey_Title];
}

+ (EAEventsDetails *)eventById:(NSString *)eventId {
	return (EAEventsDetails *)[CoreDataHelpers manageObjectInEntity:[EAEventsDetails description] withKey:EAKey_Id andValue:eventId];
}

#pragma mark - Custom method
+ (BOOL)array:(NSArray *)inputArray differsFromArray:(NSArray *)sourceArray {
	BOOL differs = NO;
	for (id element in inputArray) {
		if (![sourceArray containsObject:element]) {
			differs = YES;
			break;
		}
	}
	return differs;
}

@end
