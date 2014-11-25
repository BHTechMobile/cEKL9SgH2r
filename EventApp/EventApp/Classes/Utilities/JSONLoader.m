//
//  JSONLoader.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "JSONLoader.h"

#define URLJSON @"https://dl.dropboxusercontent.com/s/jv6b38u1jri5c99/data.json"

@implementation JSONLoader
+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLJSON]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:10];
    }
    return manager;
}

+(id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/jv6b38u1jri5c99/data.json"]];
    NSMutableURLRequest *request = [[JSONLoader sharedManager].requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[JSONLoader sharedManager].baseURL] absoluteString] parameters:dict error:nil];
    AFHTTPRequestOperation *operation =
    
    [[JSONLoader sharedManager] HTTPRequestOperationWithRequest:request
                                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                            
                                                            if (success) {
                                                                success(operation,[JSONLoader dictionaryFromData:operation.responseData error:nil]);
                                                            }
                                                            
                                                        }
                                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                            
                                                            NSLog(@"error dsds %@",[operation responseString]);
                                                            
                                                            if (error.code == NSURLErrorCancelled) {
                                                                goto CALL_FAILURE;
                                                            }
                                                            
                                                            if (error.code == NSURLErrorNotConnectedToInternet) {
                                                                goto CALL_FAILURE;
                                                            }
                                                            
                                                            if (error.code == NSURLErrorTimedOut) {
                                                                goto CALL_FAILURE;
                                                            }
                                                            
#ifdef APPDEBUG
                                                            [APP_DELEGATE alertView:@"Error" withMessage:@"Somethings was wrong, please contact to Developer" andButton:@"OK"];
#endif
                                                        CALL_FAILURE:
                                                            if (failure) {
                                                                failure(operation,error);
                                                            }
                                                            
                                                        }];
    [[JSONLoader sharedManager].operationQueue addOperation:operation];
    
}
+ (void)getJsonListWithURL:(NSURL *)url success:(void (^)( id response))success failure:(void (^)(NSError *error))failure{
    [JSONLoader requestByMethod:@"GET" widthPath:@"s/jv6b38u1jri5c99/data.json" withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ail = %@",error);
    }];
}

//+ (void)getJsonListWithURL:(NSURL *)url success:(void (^)( id response))success failure:(void (^)(NSError *error))failure{
//    dispatch_async(dispatch_queue_create("EventApp", 0), ^{
//
//        NSURLRequest *request = [NSURLRequest requestWithURL:url
//                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                             timeoutInterval:30.0];
//        NSURLResponse *response;
//        NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                             returningResponse:&response
//                                                         error:nil];
//        NSError *error = nil;
//        __block id jsonList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error ];
//
//        NSLog(@"%@",jsonList);
//
//
////        NSError* error;
////        NSDictionary* json = [NSJSONSerialization
////                              JSONObjectWithData:responseData
////                              options:kNilOptions
////                              error:&error];
//
//
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (failure) {
//                    failure(error);
//                }
//            });
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success) {
//                    success(jsonList);
//                }
//            });
//        }
//    });
//}

@end
