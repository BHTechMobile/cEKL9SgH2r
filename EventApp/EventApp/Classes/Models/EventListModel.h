//
//  EventListModel.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventListModel : NSObject

@property (nonatomic, retain) NSArray *arrayEvents;
@property (nonatomic, retain) NSString *createdBy;
@property (nonatomic, retain) NSString *nameCalendar;

- (void)getJSONfile;
- (void)fetchedData:(NSData *)responseData;
- (void)insertData:(NSArray *)arrayEvents;
    
@end
