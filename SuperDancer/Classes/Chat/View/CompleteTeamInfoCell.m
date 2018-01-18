//
//  CompleteTeamInfoCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CompleteTeamInfoCell.h"

#import "MemberCell.h"

#define kSizeHeight (kAutoWidth(60))

@interface CompleteTeamInfoCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSArray *showDataSource;

@end

static NSString *kMemberCellIdentifier = @"kMemberCellIdentifier";

@implementation CompleteTeamInfoCell


- (instancetype)initWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSInteger index = 0;
    if (indexPath.section == 0) {
        identifier = @"CompleteTeamInfoCellIdentifier0";
        index = 0;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            identifier = @"CompleteTeamInfoCellIdentifier1";
            index = 1;
        }else {
            identifier = @"CompleteTeamInfoCellIdentifier2";
            index = 2;
        }
    }else if (indexPath.section == 2) {
        identifier = @"CompleteTeamInfoCellIdentifier1";
        index = 1;
    }else {
        identifier = @"CompleteTeamInfoCellIdentifier3";
        index = 3;
    }
    CompleteTeamInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CompleteTeamInfoCell" owner:self options:nil] objectAtIndex:index];
        if (index == 1) {
            [cell showRigthArrow:NO];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//显示右边的箭头
- (void)showRigthArrow:(BOOL)isShow {
    _rightArrow.hidden = !isShow;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:NIB_NAMED(@"MemberCell") forCellWithReuseIdentifier:kMemberCellIdentifier];
    self.collectionView.userInteractionEnabled = NO;
    
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count < 5) {
        _showDataSource = _dataSource;
    }else {
        _showDataSource = [_dataSource subarrayWithRange:NSMakeRange(0, 4)];
    }
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_showDataSource count] + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeHeight, kSizeHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMemberCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.iconImg.image = IMAGE_NAMED(@"wd_add_member");
    } else {
        NIMUser *user = _showDataSource[indexPath.row - 1];
        NSString *avatarUrl = @"";
        if (user.userInfo.avatarUrl.length > 10) {
            avatarUrl = user.userInfo.avatarUrl;
        }else {
            avatarUrl = user.userInfo.thumbAvatarUrl;
        }
        [cell.iconImg setImageWithURL:[NSURL URLWithString:avatarUrl] placeholder:[UIImage imageNamed:@"myaccount"]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat topPadding = (70-kSizeHeight)/2;
    return UIEdgeInsetsMake(topPadding, 10, topPadding, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
