//
//  EventShareFacebookTableViewCell.m
//  EventApp
//
//  Created by DuongMac on 12/17/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventShareFacebookTableViewCell.h"

@implementation EventShareFacebookTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [_sharefbButton addTarget:self action:@selector(shareFbbPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)shareFbbPressed:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedButtonShareFb:)]) {
        [_delegate performSelector:@selector(clickedButtonShareFb:) withObject:btn];
    }
}

@end
