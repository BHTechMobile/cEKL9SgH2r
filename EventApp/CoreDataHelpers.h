//
// CoreDataHelpers.h
// Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JTBodyPart.h"
#import "JTExercise.h"
#import "JTMuscleGroup.h"
#import "JTWorkout.h"

@interface CoreDataHelpers : NSObject

#pragma mark - General Methods
+ (void)wipeAllData:(NSError **)error;

#pragma mark - JTBodyPart
+ (NSArray *)allBodyParts;
+ (NSArray *)bodyPartsWithNameContaining:(NSString *)name;
+ (NSArray *)allBodyPartNames;
+ (JTBodyPart *)bodyPartByName:(NSString *)name;
+ (NSArray *)bodyPartsOfFront:(BOOL)front;

#pragma mark - JTMuscleGroups
+ (NSArray *)allMuscleGroups;
+ (NSArray *)muscleGroupsWithNameContaining:(NSString *)name;
+ (NSArray *)allMuscleGroupNames;
+ (JTMuscleGroup *)muscleGroupByName:(NSString *)name;

#pragma mark - JTExercise
+ (NSArray *)allExercises;
+ (NSArray *)exercisesWithNameContaining:(NSString *)name;
+ (NSArray *)allExerciseNames;
+ (JTExercise *)exerciseByName:(NSString *)name;

#pragma mark - JTWorkouts
+ (NSArray *)allWorkouts;
+ (NSArray *)workoutsWithNameContaining:(NSString *)name;
+ (NSArray *)allWorkoutNames;
+ (JTWorkout *)workoutByName:(NSString *)name;

#pragma mark - Custom method
+ (BOOL)array:(NSArray *)inputArray differsFromArray:(NSArray *)sourceArray;
@end
