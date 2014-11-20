//
//  NSManagedObject+Utilities.h
//  Copyright (c) 2013 WeezLabs, Inc. All rights reserved.
//

#import "NSManagedObject+Utilities.h"

@implementation NSManagedObject (Utilities)

+ (NSManagedObject *)managedObjectWithKey:(NSString *)key andValue:(id)value {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
	[request setEntity:[NSEntityDescription entityForName:[[self class] description] inManagedObjectContext:JTManagedObjectContext]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = '%@'", key, value]];
	[request setPredicate:predicate];
	NSError *error = nil;
	NSArray *results = [JTManagedObjectContext executeFetchRequest:request error:&error];
	NSManagedObject *object = nil;
    
	if (results != nil) {
		if (results.count > 0) {
			object = [results objectAtIndex:0];
		}
	}
    
	return object;
}

- (void)updateFromDict:(NSDictionary *)dict {
	for (NSString *key in[dict allKeys]) {
		if ([self respondsToSelector:NSSelectorFromString(key)]) {
			[self setValue:[dict valueForKey:key] forKey:key];
		}
	}
}

@end
