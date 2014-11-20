//
//  JSONLoader.m
//  EventApp
//
//  Created by PhamHuuPhuong on 18/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "JSONLoader.h"

/*https://dl.dropboxusercontent.com/s/jv6b38u1jri5c99/data.json*/

@implementation JSONLoader

+ (void)getJsonListWithURL:(NSURL *)url success:(void (^)( id response))success failure:(void (^)(NSError *error))failure{
    dispatch_async(dispatch_queue_create("EventApp", 0), ^{
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:30.0];
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:nil];
        NSError *error = nil;
        __block id jsonList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error ];
        
        NSLog(@"%@",jsonList);
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(jsonList);
                }
            });
        }
    });
}

@end
