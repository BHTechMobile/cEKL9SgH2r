//
//  NSManagedObject+Utilities.m
//  Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSManagedObject (Utilities)

+ (NSManagedObject *)managedObjectWithKey:(NSString *)key andValue:(id)value;

- (void)updateFromDict:(NSDictionary *)dict;

@end
