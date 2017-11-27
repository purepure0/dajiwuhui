//
//  DanceTypeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DanceTypeViewController.h"
#import "DanceTypeCell.h"
#import "DanceTypeModel.h"
#define KDanceTypeCellIdentifier @"DanceTypeCellIdentifier"

@interface DanceTypeViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)NSMutableArray *videoTypeList;
@end

@implementation DanceTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"分类";
    [self initDataSource];
    [self.collectionView registerNib:NIB_NAMED(@"DanceTypeCell") forCellWithReuseIdentifier:KDanceTypeCellIdentifier];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return IMAGE_NAMED(@"nodata");
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView {
    return YES;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videoTypeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DanceTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KDanceTypeCellIdentifier forIndexPath:indexPath];
    DanceTypeModel *model = _videoTypeList[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake((kScreenWidth - 41) / 2, kAutoWidth(181));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 11;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 11;
}

#pragma mark -- 数据
- (void)initDataSource {
    
    [self showLoading];
    _videoTypeList = [NSMutableArray new];
    [PPNetworkHelper GET:NSStringFormat(@"%@%@", kApiPrefix, kVideoType) parameters:nil success:^(id responseObject) {
        [self hideLoading];
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *videoTypeArr = responseObject[@"data"][@"vedioType"];
            for (NSDictionary *dict in videoTypeArr) {
                DanceTypeModel *model = [[DanceTypeModel alloc] initDanceTypeModelWithDict:dict];
                [_videoTypeList addObject:model];
            }
            [self.collectionView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
        PPLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
