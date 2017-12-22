//
//  TeamJoinCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamJoinCell.h"
@implementation TeamJoinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (_cityLabel) {
        _cityLabel.layer.masksToBounds = YES;
        _cityLabel.layer.cornerRadius = 2;
    }
}

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath joined:(BOOL)joined {
    NSString *identifier = @"";
    NSInteger index = 0;
    if (joined == NO) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            identifier = @"TeamJoinCellFirst";
            index = 0;
        }else if (indexPath.section == 2) {
            identifier = @"TeamJoinCellThird";
            index = 2;
        }else {
            identifier = @"TeamJoinCellSecond";
            index = 1;
        }
    }else {
        if (indexPath.section == 0) {
            identifier = @"TeamJoinCellFirst";
            index = 0;
        }else if (indexPath.section == 1) {
            identifier = @"TeamJoinCellFourth";
            index = 3;
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                identifier = @"TeamJoinCellSecond";
                index = 1;
            }else {
                identifier = @"TeamJoinCellFifth";
                index = 4;
            }
        }else if (indexPath.section == 5) {
            identifier = @"TeamJoinCellThird";
            index = 2;
        }else {
            identifier = @"TeamJoinCellSecond";
            index = 1;
        }
    }
    
    TeamJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamJoinCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

+ (instancetype)initWithTableView:(UITableView *)tableView andIndex:(NSInteger)index {
    NSString *identifier = @"";
    switch (index) {
        case 0:
            identifier = @"TeamJoinCellFirst";
            break;
        case 1:
            identifier = @"TeamJoinCellSecond";
            break;
        case 2:
            identifier = @"TeamJoinCellThird";
            break;
        case 3:
            identifier = @"TeamJoinCellFourth";
            break;
        case 4:
            identifier = @"TeamJoinCellFifth";
            break;
        default:
            break;
    }
    TeamJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamJoinCell" owner:self options:nil] objectAtIndex:index];
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
    [self showRigthArrow:NO];
    self.leftLabel.text = data[@"title"];
    self.rightLabel.text = data[@"content"];
}

- (void)updateThirdCellWithData:(NSDictionary *)data {
    NSLog(@"%@", data);
    _topLabel.text = data[@"title"];
    _bottomLabel.text = data[@"content"];
}


- (void)updateFourthCellWithData:(NSDictionary *)data {
    NSArray *imgs = @[@"wd_ico_announcement", @"wd_ico_video", @"wd_ico_vote", @"wd_ico_Sign"];
    NSArray *titles = @[@"公 告", @"视 频", @"投 票", @"签 到"];
    CGFloat width = kScreenSize.width / 4;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width * i, 0, width, 98)];
        CGFloat x = (width - 48) / 2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 48, 48)];
        imageView.image = [UIImage imageNamed:imgs[i]];
        [btn addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, width, 30)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
        
        [btn addTarget:self action:@selector(actionWithButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10 + i;

        [self.contentView addSubview:btn];
    }
    
}


- (void)updateFifthCellWithData:(NSDictionary *)data {
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + 58 * i, 10, 58, 48)];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"wd_ico_group"] forState:UIControlStateNormal];
        }else if (i == 3) {
            [btn setImage:[UIImage imageNamed:@"wd_ico_invite_xiao"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(addTeamMember:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [btn setImage:[UIImage imageNamed:@"pic1"] forState:UIControlStateNormal];
        }
        [self addSubview:btn];
    }
    
}






- (IBAction)showQCode:(id)sender {
    NSLog(@"二维码");
}


- (void)addTeamMember:(id)sender {
    NSLog(@"添加队员");
    if (_addMemberBlock) {
        _addMemberBlock();
    }
}


//是否显示右边的箭头
- (void)showRigthArrow:(BOOL)isShow {
    _rightArrow.hidden = !isShow;
}

- (void)actionWithButton:(UIButton *)btn {
//    NSLog(@"%ld--%@", btn.tag, btn.titleLabel.text);
    if (_handleBtnBlock) {
        _handleBtnBlock(btn.tag);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
