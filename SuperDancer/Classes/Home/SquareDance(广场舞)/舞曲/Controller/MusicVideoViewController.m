//
//  MusicVideoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MusicVideoViewController.h"
#import "HomeCell.h"
#import "VideoListModel.h"
#import "MovePlayerViewController.h"
#define kHomeCellIdentifier @"HomeCellIdentifier"

@interface MusicVideoViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *videoList;

@end

@implementation MusicVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    _videoList = [NSMutableArray new];
    [self initDataSource];
    
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
    return _videoList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
        VideoListModel *model = self.videoList[indexPath.row];
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
    VideoListModel *model = _videoList[indexPath.row];
    MovePlayerViewController *player = [[MovePlayerViewController alloc] init];
    player.vid = model.vid;
    player.videoURL = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:player animated:model];
}



- (void)loadMore:(MJRefreshBackNormalFooter *)footer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.footer endRefreshing];
    });
}


- (void)initDataSource {
    [self showLoading];
    
    NSDictionary *body = @{@"music_id": _musicId, @"page": @(self.page)};
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kMusicSelectVideo) parameters:body success:^(id responseObject) {
        [self hideLoading];
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"data"][@"res"][@"video_list"];
            for (NSDictionary *dic in arr) {
                VideoListModel *model = [[VideoListModel alloc] initWithDict:dic];
                [_videoList addObject:model];
            }
            [self.collectionView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [self hideLoading];
        PPLog(@"%@", error.description);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
