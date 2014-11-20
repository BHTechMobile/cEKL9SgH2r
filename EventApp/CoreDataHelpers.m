//
//  CoreDataHelpers.m
//  Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//

#import "CoreDataHelpers.h"
@implementation CoreDataHelpers

#define JTKey_Name         @"name"
#define JTKey_Order        @"order"
#define JTKey_Front        @"front"

#define CONDITION_EQUAL    @"="
#define CONDITION_CONTAINS @"CONTAINS"

#define LogError(error) NSLog(@"%s - Error %@", __PRETTY_FUNCTION__, error)

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
	NSArray *managedObjects = [JTManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
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
	NSArray *entities = JTManagedObjectModel.entities;
	for (id entity in entities) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		NSArray *items = [JTManagedObjectContext executeFetchRequest:fetchRequest error:error];

		for (NSManagedObject *managedObject in items) {
			[JTManagedObjectContext deleteObject:managedObject];
			NSLog(@"%@ object deleted", [entity name]);
		}
	}
}

#pragma mark - JTBodyPart
+ (NSArray *)allBodyParts {
	return [CoreDataHelpers allMangedObjectInEntity:[JTBodyPart description] orderBy:JTKey_Order];
}

+ (NSArray *)bodyPartsWithNameContaining:(NSString *)name {
	return [CoreDataHelpers allManageObjectsInEntity:[JTBodyPart description] withKey:JTKey_Name contain:name orderBy:JTKey_Order];
}

+ (NSArray *)allBodyPartNames {
	return [CoreDataHelpers allValueOfKey:JTKey_Name inEntity:[JTBodyPart description] orderBy:JTKey_Order];
}

+ (JTBodyPart *)bodyPartByName:(NSString *)name {
	return (JTBodyPart *)[CoreDataHelpers manageObjectInEntity:[JTBodyPart description] withKey:JTKey_Name andValue:name];
}

+ (NSArray *)bodyPartsOfFront:(BOOL)front {
	return [CoreDataHelpers allManageObjectsInEntity:[JTBodyPart description] withKey:JTKey_Front condition:CONDITION_EQUAL value:[NSString stringWithFormat:@"%d", front] orderBy:JTKey_Order];
}

#pragma mark - JTMuscleGroup
+ (NSArray *)allMuscleGroups {
	return [CoreDataHelpers allMangedObjectInEntity:[JTMuscleGroup description] orderBy:nil];
}

+ (NSArray *)muscleGroupsWithNameContaining:(NSString *)name {
	return [CoreDataHelpers allManageObjectsInEntity:[JTMuscleGroup description] withKey:JTKey_Name contain:name orderBy:nil];
}

+ (NSArray *)allMuscleGroupNames {
	return [CoreDataHelpers allValueOfKey:JTKey_Name inEntity:[JTMuscleGroup description] orderBy:nil];
}

+ (JTMuscleGroup *)muscleGroupByName:(NSString *)name {
	return (JTMuscleGroup *)[CoreDataHelpers manageObjectInEntity:[JTMuscleGroup description] withKey:JTKey_Name andValue:name];
}

#pragma mark - JTExercise
+ (NSArray *)allExercises {
	return [CoreDataHelpers allMangedObjectInEntity:[JTExercise description] orderBy:nil];
}

+ (NSArray *)exercisesWithNameContaining:(NSString *)name {
	return [CoreDataHelpers allManageObjectsInEntity:[JTExercise description] withKey:JTKey_Name contain:name orderBy:nil];
}

+ (NSArray *)allExerciseNames {
	return [CoreDataHelpers allValueOfKey:JTKey_Name inEntity:[JTExercise description] orderBy:nil];
}

+ (JTExercise *)exerciseByName:(NSString *)name {
	return (JTExercise *)[CoreDataHelpers manageObjectInEntity:[JTExercise description] withKey:JTKey_Name andValue:name];
}

#pragma mark - JTWorkOut
+ (NSArray *)allWorkouts {
	return [CoreDataHelpers allMangedObjectInEntity:[JTWorkout description] orderBy:nil];
}

+ (NSArray *)workoutsWithNameContaining:(NSString *)name {
	return [CoreDataHelpers allManageObjectsInEntity:[JTWorkout description] withKey:JTKey_Name contain:name orderBy:nil];
}

+ (NSArray *)allWorkoutNames {
	return [CoreDataHelpers allValueOfKey:JTKey_Name inEntity:[JTWorkout description] orderBy:nil];
}

+ (JTWorkout *)workoutByName:(NSString *)name {
	return (JTWorkout *)[CoreDataHelpers manageObjectInEntity:[JTWorkout description] withKey:JTKey_Name andValue:name];
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
