//
//  JSONLoader.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface JSONLoader : NSObject

+(AFHTTPRequestOperationManager*)sharedManager;
+(void)requestDataSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
