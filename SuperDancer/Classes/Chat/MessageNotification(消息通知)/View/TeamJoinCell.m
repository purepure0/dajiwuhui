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
    self.heightLayout1.constant = kAutoHeight(40);
    self.heightLayout2.constant = kAutoHeight(20);
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = kAutoWidth(38);
    
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

            if (!indexPath.row) {
                identifier = @"TeamJoinCellSecond";
                index = 1;
            } else {
                identifier = @"TeamJoinCellFifth";
                index = 4;
            }
        }else if (indexPath.section == 2) {
            identifier = @"TeamJoinCellSecond";
            index = 1;
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
    NSLog(@"FirstCellWithData == %@", data);
    [self.iconImageView setImageWithURL:[NSURL URLWithString:data[@"icon"]] placeholder:IMAGE_NAMED(@"avatar_team")];
    self.iconImageView.userInteractionEnabled = [data[@"isTeamOwner"] boolValue];
    self.nicknameLabel.text = data[@"nickname"];
    self.cityLabel.text = data[@"city"];
}

- (IBAction)iconImgAction:(id)sender
{
    if (_iconImgBlock) {
        _iconImgBlock();
    }
}

- (void)updateSecondCellWithData:(NSDictionary *)data {
//    NSLog(@"%@", data);
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


- (void)updateFifthCellWithData:(NSArray<NIMUser *> *)members
{
    _teamMemberLabel.text = NSStringFormat(@"%ld名队友",members.count);
    
    UIView *memberContainer = [[UIView alloc] init];
    [self.contentView addSubview:memberContainer];
    
    NSArray *subarray;
    if ([members count] > 4) {
        subarray = [members subarrayWithRange:NSMakeRange(0, 4)];
    } else {
        subarray = members;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < subarray.count + 1; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [memberContainer addSubview:btn];
        btn.sd_layout.autoHeightRatio(1);
        btn.sd_cornerRadiusFromWidthRatio = @(0.5);
        [temp addObject:btn];
        
        if (!i) {
            [btn setImage:IMAGE_NAMED(@"wd_add_member") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(addTeamMemberAction) forControlEvents:UIControlEventTouchUpInside];
        } else {
            NIMUser *user = [subarray objectAtIndex:i-1];
            [btn setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] forState:UIControlStateNormal placeholder:IMAGE_NAMED(@"placeholder_img")];
            if (i==1) {
                UIImageView *creatorView = [[UIImageView alloc] init];
                creatorView.image = IMAGE_NAMED(@"icon_team_creator");
                [memberContainer addSubview:creatorView];
                creatorView.sd_layout
                .bottomEqualToView(btn)
                .rightEqualToView(btn)
                .widthIs(20)
                .heightEqualToWidth();
            }
        }
    }
    
    [memberContainer setupAutoMarginFlowItems:[temp copy] withPerRowItemsCount:5 itemWidth:kAutoWidth(50) verticalMargin:10 verticalEdgeInset:4 horizontalEdgeInset:10];
    
    memberContainer.sd_layout
    .leftEqualToView(self.contentView)
    .rightSpaceToView(self.teamMemberLabel, 0)
    .centerYEqualToView(self.contentView);
}

#pragma mark - 舞队二维码

- (IBAction)showQCode:(id)sender {
//    NSLog(@"二维码");
    if (self.qRCodeBlock) {
        self.qRCodeBlock();
    }
}


- (void)addTeamMemberAction {
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
//    if (_handleBtnBlock) {
//        _handleBtnBlock(btn.tag);
//    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
