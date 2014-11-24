//
//  EventDetailMapTableViewCell.h
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventDetailMapTableViewCellDelegate <NSObject>

- (void)clickedButtonLocation:(UIButton *)btnLocation;

@end

@interface EventDetailMapTableViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,assign) id<EventDetailMapTableViewCellDelegate> delegate;
@property (nonatomic, retain) UIButton *_locationButton;

@property (weak, nonatomic) IBOutlet UITextView *contentLocation;
@property (weak, nonatomic) IBOutlet UIView *mapViewContent;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

- (IBAction)linkLocationMap:(id)sender;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
