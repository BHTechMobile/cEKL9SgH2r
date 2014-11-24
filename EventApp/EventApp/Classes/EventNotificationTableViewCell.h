//
//  EventNotificationTableViewCell.h
//  EventApp
//
//  Created by PhamHuuPhuong on 21/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventNotificationTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentNotification;
- (IBAction)addNotificationAction:(id)sender;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
