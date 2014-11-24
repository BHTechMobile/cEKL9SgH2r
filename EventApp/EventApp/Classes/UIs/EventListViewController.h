//
//  EventListViewController.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)refreshListEventsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *listEventsTable;
@property (strong, nonatomic) NSArray *getListEvents;

@end
