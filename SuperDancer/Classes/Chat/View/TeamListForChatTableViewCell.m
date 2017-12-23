//
//  TeamListForChatTableViewCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamListForChatTableViewCell.h"

@implementation TeamListForChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 - 1, kScreenSize.width, 1)];
    lineView.backgroundColor = kLineColor;
}

- (instancetype)initCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:@"TeamListForChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeamListForChatTableViewCell"];
    TeamListForChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamListForChatTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TeamListForChatTableViewCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)updateCellWithTeamData:(NIMTeam *)team {
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholder:[UIImage imageNamed:@"pic"]];
    self.teamNameLabel.text = team.teamName;
    self.addressLabel.text = @"所在地区：山东省菏泽市";
    self.addressLabel.textColor = kTextGrayColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
