//
//  EventDescriptionTableViewCell.m
//  EventApp
//
//  Created by PhamHuuPhuong on 21/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "EventDescriptionTableViewCell.h"

@implementation EventDescriptionTableViewCell

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
