//
//  EventDetailMapTableViewCell.h
//  EventApp
//
//  Created by PhamHuuPhuong on 21/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailMapTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentLocation;
@property (weak, nonatomic) IBOutlet UIView *mapViewContent;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

- (IBAction)linkLocationMap:(id)sender;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
