//
//  JSONLoader.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "JSONLoader.h"
/*&prettyprint=true*/
//#define URLJSON @"https://www.google.com/calendar/feeds/calendars@startupdigest.com/public/basic?alt=json&max-results=1000&start-index=1500&orderby=starttime&sortorder=d&hl=en"
#define URLJSON @"https://www.google.com/calendar/feeds/calendars@startupdigest.com/public/basic?alt=json&max-results=1000&orderby=starttime&sortorder=d&hl=en"

@implementation JSONLoader
+(AFHTTPRequestOperationManager*)sharedManager{
    static AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return manager;
}

+(void)requestDataSuccess:(SuccessBlock)success failure:(FailureBlock)failure{
    [[JSONLoader sharedManager] GET:URLJSON parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            if (failure) {
                failure(operation,error);
            }
        }
        else if (success) {
            success(operation,dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}


@end
