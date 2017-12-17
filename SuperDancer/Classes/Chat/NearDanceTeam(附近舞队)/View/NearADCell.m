//
//  NearADCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "NearADCell.h"
#import "ScrollViewCell.h"

@interface NearADCell ()<ScrollViewCellDelegate>


@end

static NSString *kScrollViewCellIdentifier = @"kScrollViewCellIdentifier";

@implementation NearADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.pageControl.numberOfPages = 4;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:NIB_NAMED(@"ScrollViewCell") forCellWithReuseIdentifier:kScrollViewCellIdentifier];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 10, CGRectGetHeight(collectionView.bounds) - 10);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScrollViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark - ScrollViewCellDelegate

- (void)applyJoinTeamButtonAction:(ScrollViewCell *)scrollViewCell
{
    PPLog(@"申请加入！！");
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    ScrollViewCell *cell = [[self.collectionView visibleCells] firstObject];
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 设置页码
    self.pageControl.currentPage = page;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
