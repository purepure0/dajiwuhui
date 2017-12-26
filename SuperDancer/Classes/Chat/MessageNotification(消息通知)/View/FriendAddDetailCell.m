//
//  FriendAddDetailCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FriendAddDetailCell.h"

@implementation FriendAddDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    if (_cityLabel) {
//        _cityLabel.layer.masksToBounds = YES;
//        _cityLabel.layer.cornerRadius = 2;
//    }
    if (_iconImageView) {
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 35;
    }
}

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSInteger index = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        identifier = @"FriendAddDetailCell0";
        index = 0;
    }else if (indexPath.section == 2) {
        identifier = @"FriendAddDetailCell2";
        index = 2;
    }else {
        identifier = @"FriendAddDetailCell1";
        index = 1;
    }
    FriendAddDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendAddDetailCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)updateFirstCellWithAvatarUrl:(NSString *)avatarUrl nickname:(NSString *)nickname {
    [self.iconImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholder:[UIImage imageNamed:@"myaccount"]];
    self.nicknameLabel.text = nickname;
}

- (void)updateSecondCellWithTitle:(NSString *)title content:(NSString *)content {
    self.leftLabel.text = title;
    self.rightLabel.text = content;
}

- (void)updateThirdCellWithTitle:(NSString *)title introduction:(NSString *)intro {
    _topLabel.text = title;
    _bottomLabel.text = intro;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
