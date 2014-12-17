//
//  EventShareFacebookTableViewCell.h
//  EventApp
//
//  Created by DuongMac on 12/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EventShareFacebookTableViewCellDelegate <NSObject>
- (void)clickedButtonShareFb:(UIButton *)btnShareFb;
@end

@interface EventShareFacebookTableViewCell : UITableViewCell <UITextViewDelegate>
@property (nonatomic,assign) id<EventShareFacebookTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *sharefbButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
