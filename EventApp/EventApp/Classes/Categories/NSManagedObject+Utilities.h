//
//  NSManagedObject+Utilities.m
//

#import <Foundation/Foundation.h>

@interface NSManagedObject (Utilities)

+ (NSManagedObject *)managedObjectWithKey:(NSString *)key andValue:(id)value;

- (void)updateFromDict:(NSDictionary *)dict;

@end
