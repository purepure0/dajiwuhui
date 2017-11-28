//
//  LocalDanceViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "LocalDanceViewController.h"
#import "HomeCell.h"
#import "VideoListModel.h"
#import "MovePlayerViewController.h"

#define kLocalCellIdentifier @"LocalCellIdentifier"
#define kReloadWithDistrictID @"ReloadWithDistrictID"
#define kLocationFailNotification @"locationFailNotification"
@interface LocalDanceViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *videoList;
@property (nonatomic, copy)NSString *districtID;



@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *district;

@end

@implementation LocalDanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _districtID = [[NSString alloc] init];
    [self.rightBtn setTitle:self.users.districtSelected forState:UIControlStateNormal];
    [self initDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDistrictID:) name:kReloadWithDistrictID object:nil];
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isFreshing = YES;
        [self initDataSource];
    }];
    self.collectionView.mj_header = self.header;
    
    [self.collectionView registerNib:NIB_NAMED(@"HomeCell") forCellWithReuseIdentifier:kLocalCellIdentifier];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return IMAGE_NAMED(@"nodata");
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView {
    return YES;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoList.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLocalCellIdentifier forIndexPath:indexPath];
    VideoListModel *model = _videoList[indexPath.row];
    [cell setModel:model];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovePlayerViewController *movePlayer = [[MovePlayerViewController alloc] init];
    VideoListModel *model = _videoList[indexPath.row];
    movePlayer.vid = model.vid;
    movePlayer.videoURL = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:movePlayer animated:YES];
}

#pragma mark -- 数据
- (void)initDataSource {
    _videoList = [NSMutableArray new];
    [self showLoading];
    NSDictionary *body = nil;
    NSLog(@"%@", self.users.districtID);
    if (self.users.districtID) {
        body = @{@"district_id": self.users.districtID}; 
    }else {
        body = @{@"city": self.users.cityLocation, @"district": self.users.districtLocation};
    }
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kLocal) parameters:body success:^(id responseObject) {
        [self hideLoading];
        PPLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *videoIndex = responseObject[@"data"][@"Video_local"];
            for (NSDictionary *dict in videoIndex) {
                VideoListModel *model = [[VideoListModel alloc] initWithDict:dict];
                [_videoList addObject:model];
            }
            [_collectionView reloadData];
        }else {
            [self toast:responseObject[@"message"]];
        }
        if (self.isFreshing) {
            self.isFreshing = NO;
            [self.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        if (self.isFreshing) {
            self.isFreshing = NO;
            [self.header endRefreshing];
        }
        [self hideLoading];
    }];
    
}

- (void)updateDistrictID:(NSNotification *)noti {
    NSLog(@"更新地区");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeDistrict" object:nil];
    [self initDataSource];

}


//- (void)reloadDataSource {
//
//    [_videoList removeAllObjects];
//    [self showLoading];
//    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kLocal) parameters:@{@"district_id": _districtID} success:^(id responseObject) {
//        [self hideLoading];
////        PPLog(@"%@", responseObject);
//        [self toast:responseObject[@"message"]];
//        NSArray *videoIndex = responseObject[@"data"][@"Video_local"];
//        for (NSDictionary *dict in videoIndex) {
//            VideoListModel *model = [[VideoListModel alloc] initWithDict:dict];
//            [_videoList addObject:model];
//        }
//        [_collectionView reloadData];
//        if (self.isFreshing) {
//            self.isFreshing = NO;
//            [self.header endRefreshing];
//        }
//
//    } failure:^(NSError *error) {
//        PPLog(@"%@", error.description);
//        [self hideLoading];
//        if (self.isFreshing) {
//            self.isFreshing = NO;
//            [self.header endRefreshing];
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
