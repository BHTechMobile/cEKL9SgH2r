//
//  EventDetailViewController.h
//  EventApp
//
//  Created by Tommy on 11/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAEventsDetails.h"
#import "EventDetailModel.h"

@interface EventDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    EventDetailModel* _eventDetailModel;
}
-(void)setEvent:(EAEventsDetails *)event;

@end
