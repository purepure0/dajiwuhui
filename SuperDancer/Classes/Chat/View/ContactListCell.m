//
//  ContactListCell.m
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell
{
    NSString *_placeHolderImageName;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 25;
}

- (instancetype)initCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactListCellIdentifier"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactListCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        _placeHolderImageName = @"myaccount";
    }else {
        _placeHolderImageName = @"team_avatar";
    }
    return cell;
}

- (void)updateCellWithName:(NSString *)name info:(NSString *)info imageUrl:(NSString *)imageUrl {
    _nameLabel.text = name;
    _infoLabel.text = info;
    [_avatarImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"myaccount"]];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
