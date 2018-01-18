//
//  ChildDanceViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ChildDanceViewController.h"
#import "HomeCell.h"
#import "ButtonCell.h"
#import "HeaderReusableView.h"
#import "VideoListModel.h"
#import "MovePlayerViewController.h"
#import "MoreVideoViewController.h"
#import "DancersViewController.h"
#import "DanceTypeViewController.h"
#import "MusicViewController.h"
#define kHomeCellIdentifier @"HomeCellIdentifier"
#define kHeaderReusableViewIdentifier @"HeaderReusableViewIdentifier"
#define kFooterReusableViewIdentifier @"FooterReusableViewIdentifier"

#define kButtonCellIdentifier @"ButtonCellIdentifier"

@interface ChildDanceViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *videoList;
@end

@implementation ChildDanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isFreshing = YES;
        [self initDataSource];
    }];
    self.collectionView.mj_header = self.header;
    
    [self.collectionView registerNib:NIB_NAMED(@"HomeCell") forCellWithReuseIdentifier:kHomeCellIdentifier];
    
    [self.collectionView registerNib:NIB_NAMED(@"HeaderReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReusableViewIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReusableViewIdentifier];
    
    [self.collectionView registerNib:NIB_NAMED(@"ButtonCell") forCellWithReuseIdentifier:kButtonCellIdentifier];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        if (_videoList.count == 0) {
            return 0;
        }else {
            return [_videoList[section - 1] count];
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kButtonCellIdentifier forIndexPath:indexPath];
        NSArray *images = @[@"ch_dancer",@"ch_dancemusic",@"ch_classify"];
        
        for (int i = 0; i < cell.btns.count; i++) {
            UIButton *btn = cell.btns[i];
            [btn setImage:IMAGE_NAMED(images[i]) forState:UIControlStateNormal];
        }
        for (UIButton *btn in cell.btns) {
            [btn addTarget:self action:@selector(btnsAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    else
    {
        HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
        VideoListModel *model = self.videoList[indexPath.section - 1][indexPath.row];
        [cell setModel:model];
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? CGSizeMake(kScreenWidth, kAutoWidth(117)) : CGSizeMake((kScreenWidth-35)/2, kAutoWidth(140));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_videoList.count == 0) {
        return UIEdgeInsetsZero;
    }
    return section == 0 ? UIEdgeInsetsZero : UIEdgeInsetsMake(15, 15, 15, 15);
}

// 添加头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HeaderReusableView *header = (HeaderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderReusableViewIdentifier forIndexPath:indexPath];
        
        reusableView = header;
        [header.moreBtn addTarget:self action:@selector(getMoreVideo:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.section == 1)
        {
            header.titleLabel.text = @"每日精选";
            header.moreBtn.tag = 100;
        }
        else if (indexPath.section == 2)
        {
            header.titleLabel.text = @"舞者原创";
            header.moreBtn.tag = 101;
        }
        else if (indexPath.section == 3)
        {
            header.titleLabel.text = @"热门视频";
            header.moreBtn.tag = 102;
        }
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReusableViewIdentifier forIndexPath:indexPath];
        footer.backgroundColor = [UIColor colorWithHexString:@"FBFBFB"];
        reusableView = footer;
    }
    return reusableView;
}

// 设置头视图的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGSizeZero : CGSizeMake(kScreenWidth, 55);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return section == 0 || section == 3 ? CGSizeZero : CGSizeMake(kScreenWidth, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        MovePlayerViewController *movePlayer = [[MovePlayerViewController alloc] init];
        VideoListModel *model = self.videoList[indexPath.section - 1][indexPath.row];
        movePlayer.vid = model.vid;
        movePlayer.videoURL = [NSURL URLWithString:model.url];
        [self.navigationController pushViewController:movePlayer animated:YES];
    }
}
    
#pragma mark -- 数据
- (void)initDataSource {
    _videoList = [NSMutableArray new];
    MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper GET:NSStringFormat(@"%@%@", kApiPrefix, kChildren) parameters:nil success:^(id responseObject) {
        PPLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *videoIndex = responseObject[@"data"][@"Video_chiidren"];
            NSArray *videoArr = @[videoIndex[@"everyday"], videoIndex[@"original"], videoIndex[@"hot"]];
            for (NSArray *arr in videoArr) {
                NSMutableArray *list = [NSMutableArray new];
                for (NSDictionary *dict in arr) {
                    VideoListModel *model = [[VideoListModel alloc] initWithDict:dict];
                    [list addObject:model];
                }
                [_videoList addObject:list];
            }
            PPLog(@"%@", self.videoList);
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

#pragma mark -- 查看更多

- (void)getMoreVideo:(UIButton *)btn {
    MoreVideoViewController *moreVideo = [[MoreVideoViewController alloc] init];
    if (btn.tag == 100) {
        moreVideo.title = @"每日精选";
    }else if (btn.tag == 101) {
        moreVideo.title = @"舞者原创";
    }else if (btn.tag == 102) {
        moreVideo.title = @"热门视频";
    }
    [self.navigationController pushViewController:moreVideo animated:YES];
}

#pragma mark - Btns Action
- (void)btnsAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
            DancersViewController *dancer = [[DancersViewController alloc] init];
            dancer.type = 1;
            [MobClick event:@"click4"];
            [self.navigationController pushViewController:dancer animated:YES];
        }
            break;
        case 2:
        {
            MusicViewController *music = [[MusicViewController alloc] init];
            music.type = @"1";
            [MobClick event:@"click5"];
            [self.navigationController pushViewController:music animated:YES];
        }
            break;
        case 3:{
            DanceTypeViewController *danceType = [[DanceTypeViewController alloc] init];
            [MobClick event:@"click6"];
            [self.navigationController pushViewController:danceType animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
