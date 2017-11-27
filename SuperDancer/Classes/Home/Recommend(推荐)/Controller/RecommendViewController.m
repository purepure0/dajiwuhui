//
//  RecommendViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "RecommendViewController.h"
#import "MovePlayerViewController.h"
#import "HomeCell.h"
#import "VideoListModel.h"
#define kHomeCellIdentifier @"HomeCellIdentifier"

@interface RecommendViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *videoList;


@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
//    self.users.userId = @"81516";
//    self.users.token = @"oaMKIwmXVHfP5r03012sOl5mQP3k";
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isFreshing = YES;
        [self initDataSource];
    }];
    self.collectionView.mj_header = self.header;
    [self.collectionView registerNib:NIB_NAMED(@"HomeCell") forCellWithReuseIdentifier:kHomeCellIdentifier];
    
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
    VideoListModel *model = _videoList[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovePlayerViewController *movePlayer = [[MovePlayerViewController alloc] init];
    VideoListModel *model = _videoList[indexPath.row];
//    movePlayer.model = model;
    movePlayer.vid = model.vid;
    movePlayer.videoURL = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:movePlayer animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-35)/2, kAutoWidth(140));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


#pragma mark -- 数据
- (void)initDataSource {
    _videoList = [NSMutableArray new];
    MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper GET:NSStringFormat(@"%@%@", kApiPrefix, kIndex) parameters:nil success:^(id responseObject) {
        PPLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *videoIndex = responseObject[@"data"][@"Video_Index"];
            for (NSDictionary *dict in videoIndex) {
                VideoListModel *model = [[VideoListModel alloc] initWithDict:dict];
                [_videoList addObject:model];
            }
            [_collectionView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        if (self.isFreshing) {
            self.isFreshing = NO;
            [self.header endRefreshing];
        }
        [mb hide:YES afterDelay:0.2];
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        if (self.isFreshing) {
            self.isFreshing = NO;
            [self.header endRefreshing];
        }
        [mb hide:YES afterDelay:0.2];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
