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

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

static NSString *kMemberCellIdentifier = @"kMemberCellIdentifier";

@implementation CompleteTeamInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:NIB_NAMED(@"MemberCell") forCellWithReuseIdentifier:kMemberCellIdentifier];
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"", nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count] + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeHeight, kSizeHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMemberCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == [self.dataSource count]) {
        cell.iconImg.image = IMAGE_NAMED(@"wd_ico_invite_xiao");
    } else {
        cell.iconImg.image = IMAGE_NAMED(@"wd_ico_ewm");
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.dataSource count]) {
        [self.dataSource insertObject:@"" atIndex:0];
        
        // 每行展示5个Item，多余的部分不展示
        if ([self.dataSource count] <= 4) {
            [self.collectionView reloadData];
        }
    }
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
