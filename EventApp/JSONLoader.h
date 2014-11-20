//
//  JSONLoader.h
//  EventApp
//
//  Created by PhamHuuPhuong on 18/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONLoader : NSObject

+(void)getJsonListWithURL:(NSURL *)url success:(void (^)( id response))success failure:(void (^)(NSError *error))failure;

@end
