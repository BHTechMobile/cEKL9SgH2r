//
//  EventListTableViewCell.m
//  EventApp
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventListTableViewCell.h"

@implementation EventListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timeTitleEvents.textColor = [UIColor grayColor];
    }
    return self;
}

@end
