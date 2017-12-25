//
//  FriendNotiDetailCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FriendNotiDetailCell.h"

@implementation FriendNotiDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (_cityLabel) {
        _cityLabel.layer.masksToBounds = YES;
        _cityLabel.layer.cornerRadius = 2;
    }
    
    if (_avatarImageView) {
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 35;
    }
}

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSInteger index = 0;
    if (indexPath.row == 0) {
        identifier = @"FriendNotiDetailCellFirst";
        index = 0;
    }else if (indexPath.row == 1) {
        identifier = @"FriendNotiDetailCellSecond";
        index = 2;
    }
    FriendNotiDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendNotiDetailCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)updateFirstCellWithAvatarUrl:(NSString *)avatarUrl nickname:(NSString *)nickname city:(NSString *)city {
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholder:[UIImage imageNamed:@"pic1"]];
    self.nicknameLabel.text = nickname;
    self.cityLabel.text = city;
    
}

- (void)updateSecondCellWithpersonIntro:(NSString *)intro {
    
    self.personIntro.text = intro;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
