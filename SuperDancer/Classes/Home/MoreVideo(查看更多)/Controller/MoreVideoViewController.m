//
//  MoreVideoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/14.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MoreVideoViewController.h"
#import "HomeCell.h"
#define kHomeCellIdentifier @"HomeCellIdentifier"

@interface MoreVideoViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MoreVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.header endRefreshing];
        });
    }];
    self.collectionView.mj_header = self.header;
    
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    self.collectionView.mj_footer = self.footer;
    
    [_collectionView registerNib:NIB_NAMED(@"HomeCell") forCellWithReuseIdentifier:kHomeCellIdentifier];
    
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 13;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
//    VideoListModel *model = self.videoList[indexPath.section - 1][indexPath.row];
//    [cell setModel:model];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-35)/2, kAutoWidth(140));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)loadMore:(MJRefreshBackNormalFooter *)footer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.footer endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
