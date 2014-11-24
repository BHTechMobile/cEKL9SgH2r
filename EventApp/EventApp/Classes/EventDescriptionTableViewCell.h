//
//  EventDescriptionTableViewCell.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDescriptionTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentDescription;
@property (weak, nonatomic) IBOutlet UILabel *contentDescriptionLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
