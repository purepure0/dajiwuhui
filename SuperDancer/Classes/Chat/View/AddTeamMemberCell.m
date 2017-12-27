//
//  AddTeamMemberCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AddTeamMemberCell.h"

@implementation AddTeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 30;
    [self setIsSelected:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tap:(id)sender {
    [self setIsSelected:!_isSelected];
    if (_selectedBlock && _userID) {
        _selectedBlock(_userID);
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        _markImageView.image = [UIImage imageNamed:@"icon_accessory_selected"];
    }else {
        _markImageView.image = [UIImage imageNamed:@"icon_accessory_normal"];
    }
}


@end
