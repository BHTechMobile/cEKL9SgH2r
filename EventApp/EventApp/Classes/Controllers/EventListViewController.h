//
//  EventListViewController.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

- (IBAction)refreshListEventsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *listEventsTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshListEvents;
@property (weak, nonatomic) IBOutlet UISearchBar *searchEventBar;
@property (strong, nonatomic) NSMutableArray *searchListEvents;

@end
