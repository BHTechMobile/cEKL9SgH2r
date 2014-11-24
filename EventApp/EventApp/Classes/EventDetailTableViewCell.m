//
//  EventDetailTableViewCell.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventDetailTableViewCell.h"

@implementation EventDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
