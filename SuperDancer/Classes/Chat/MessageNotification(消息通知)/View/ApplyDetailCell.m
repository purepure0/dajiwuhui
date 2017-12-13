//
//  ApplyDetailCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ApplyDetailCell.h"

@implementation ApplyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (_cityLabel) {
        _cityLabel.layer.masksToBounds = YES;
        _cityLabel.layer.cornerRadius = 2;
    }
}

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSInteger index = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        identifier = @"ApplyDetailCellFirst";
        index = 0;
    }else if (indexPath.section == 2) {
        identifier = @"ApplyDetailCellThird";
        index = 2;
    }else {
        identifier = @"ApplyDetailCellSecond";
        index = 1;
    }
    ApplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyDetailCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)updateFirstCellWithData:(NSDictionary *)data {
    NSLog(@"%@", data);
    self.iconImageView.image = [UIImage imageNamed:data[@"icon"]];
    self.nicknameLabel.text = data[@"nickname"];
    self.cityLabel.text = data[@"city"];
    
}

- (void)updateSecondCellWithData:(NSDictionary *)data {
    NSLog(@"%@", data);
    self.leftLabel.text = data[@"title"];
    self.rightLabel.text = data[@"content"];
}

- (void)updateThirdCellWithData:(NSDictionary *)data {
    NSLog(@"%@", data);
    _topLabel.text = data[@"title"];
    _bottomLabel.text = data[@"content"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
