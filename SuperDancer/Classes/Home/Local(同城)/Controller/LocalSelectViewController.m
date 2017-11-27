//
//  LocalSelectViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "LocalSelectViewController.h"
#import "LocalCell.h"
#import "LocalHeaderReusableView.h"
#define kLocalCellIdentifier @"LocalCellIdentifier"
#define kLocalHeaderIdentifier @"kLocalHeaderIdentifier"
#define kReloadWithDistrictID @"ReloadWithDistrictID"

@interface LocalSelectViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *districtList;
@end

@implementation LocalSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self.collectionView registerNib:NIB_NAMED(@"LocalCell") forCellWithReuseIdentifier:kLocalCellIdentifier];
//    [self.collectionView registerNib:NIB_NAMED(@"LocalHeaderReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLocalHeaderIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _districtList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LocalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLocalCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = _districtList[indexPath.row];
    cell.label.text = dic[@"district_name"];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kAutoWidth(97), kAutoWidth(32));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kAutoWidth(27);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kAutoWidth(15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _districtList[indexPath.row];
    PPLog(@"aaa=%@", dic);
    self.users.districtID = dic[@"district_id"];
    self.users.districtSelected = dic[@"district_name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWithDistrictID object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


// 添加头视图
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableView = nil;
//
//    if([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        LocalHeaderReusableView *header = (LocalHeaderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kLocalHeaderIdentifier forIndexPath:indexPath];
//        reusableView = header;
//    }
//    return reusableView;
//}
// 设置头视图的宽高
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(kScreenWidth, kAutoHeight(25));
//}

- (void)initDataSource {
    [self showLoading];
    _districtList = [NSArray new];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kDistrict) parameters:@{@"city_id": _cityID} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            _districtList = responseObject[@"data"][@"district_list"];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
            
        }
        [_collectionView reloadData];
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
