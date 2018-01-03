//
//  PersonalCenterViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import <QiniuSDK.h>
#import "HomeCell.h"
#import "PersonalHeaderView.h"
#import "VideoListModel.h"
#import "MovePlayerViewController.h"
#import "EditProfileViewController.h"
#define kHomeCellIdentifier @"HomeCellIdentifier"
#define kHeaderReusableViewIdentifier @"PersonalHeaderReusableViewIdentifier"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 197
#define NAV_HEIGHT 64

#define SCROLL_DOWN_LIMIT 70
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface PersonalCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, strong) NSMutableArray *videoList;

@property (nonatomic, strong) NSDictionary *fans;

@property (nonatomic, strong)PersonalHeaderView *headerView;

@property (nonatomic, strong)UIImagePickerController *imagePicker;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavBar];
    self.navigationItem.title = @"";
    
    [self.collectionView registerNib:NIB_NAMED(@"HomeCell") forCellWithReuseIdentifier:kHomeCellIdentifier];
    [self.collectionView registerNib:NIB_NAMED(@"PersonalHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReusableViewIdentifier];

    [self loadPersonalInfoData];
    self.page = 1;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPersonalInfoData)];
}

#warning 只有uid=1有数据！
- (void)loadPersonalInfoData
{
    self.page++;
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,kPersonalCenter) parameters:@{@"user_id":self.userId,@"page":@(self.page)} success:^(id responseObject) {
        PPLog(@"Personal center == %@",responseObject);
        NSString *code =  NSStringFormat(@"%@",responseObject[@"code"]);
        if ([code isEqualToString:@"0"]) {
            [self hideLoading];
            NSDictionary *data = responseObject[@"data"];
            NSDictionary *user = data[@"video"][@"user"];
            NSDictionary *fans = data[@"video"][@"fans"];
            self.fans = fans;
            self.userInfo = [[UserInfo alloc] initWithDict:user];
            self.users.signature = self.userInfo.signature;
            NSArray *videoList = data[@"video"][@"videoList"];
            if (videoList.count != 0) {
                for (NSDictionary *dict in videoList) {
                    VideoListModel *model = [[VideoListModel alloc] initWithDict:dict];
                    [self.videoList addObject:model];
                }
                
            } else {
                self.collectionView.mj_footer.hidden = YES;
            }
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self hideLoading];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)configureNavBar
{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage new]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share_white"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollViewDidScroll:_collectionView];
    });
    self.navigationController.navigationBar.translucent = YES;
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNavBarShadowImageHidden:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNavBarShadowImageHidden:NO];
}

    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIView *barBackgroundView = navigationBar.subviews.firstObject;
    
//    PPLog(@"%lf",offsetY);
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;

        [self setStatusBarStyle:UIStatusBarStyleDefault];
        [navigationBar setBarTintColor:[UIColor whiteColor]];
        [navigationBar setTintColor:[UIColor blackColor]];
        barBackgroundView.alpha = alpha;
        barBackgroundView.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.title = self.userInfo.nick_name;
    }
    else
    {
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        [navigationBar setBarTintColor:[UIColor whiteColor]];
        [navigationBar setTintColor:[UIColor whiteColor]];
        barBackgroundView.alpha = 0;
        barBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.navigationItem.title = @"";
    }
}


- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
    VideoListModel *model = self.videoList[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MovePlayerViewController *movePlayer = [[MovePlayerViewController alloc] init];
    VideoListModel *model = _videoList[indexPath.row];
    movePlayer.vid = model.vid;
    movePlayer.videoURL = [NSURL URLWithString:model.url];
//    movePlayer.model = model;
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

// 添加头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        self.headerView = (PersonalHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderReusableViewIdentifier forIndexPath:indexPath];
        self.headerView.backgroundColor = [UIColor whiteColor];
        
        [self.headerView updateUserInfo:self.userInfo];
        // 编辑
        if ([self.userId isEqualToString:self.users.userId]) {
//            self.headerView.editBtn.tag = 1;
//            [self.headerView.editBtn setImage:IMAGE_NAMED(@"my_profile_edit") forState:UIControlStateNormal];
            self.headerView.editBtn.hidden = YES;
            @weakify(self);
            _headerView.changeBgImageBlock = ^ {
                @strongify(self);
                [self uploadImage];
            };
            // 关注
        } else {
            self.headerView.editBtn.hidden = NO;
            NSString *code = NSStringFormat(@"%@",self.fans[@"code"]);
            if ([code isEqualToString:@"2"]) {// 1:已关注
                self.headerView.editBtn.tag = 2;
                [self.headerView.editBtn setImage:IMAGE_NAMED(@"yiguanzhu") forState:UIControlStateNormal];
            } else { // 2:未关注
                self.headerView.editBtn.tag = 3;
                [self.headerView.editBtn setImage:IMAGE_NAMED(@"guanzhu") forState:UIControlStateNormal];
            }
        }
        
        @weakify(self);
        self.headerView.editBtnBlock = ^(UIButton *btn) {
            @strongify(self);
            [self editAction:btn];
        };
        
        return self.headerView;
    }
    return nil;
}

#pragma mark - EditAction

- (void)editAction:(UIButton *)btn
{
    if (btn.tag == 1) { // 编辑
//        EditProfileViewController *edit = [[EditProfileViewController alloc] init];
//        [self.navigationController pushViewController:edit animated:YES];
    } else { // 关注/未关注
        [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,kAttention) parameters:@{@"uid":self.userId} success:^(id responseObject) {
            PPLog(@"关注/取消关注 == %@",responseObject);
            NSString *code = NSStringFormat(@"%@",responseObject[@"code"]);
            if ([code isEqualToString:@"0"]) {
                if ([responseObject[@"message"] isEqualToString:@"取消关注成功"]) {
                    [self toast:@"已取消关注"];
                    [btn setImage:IMAGE_NAMED(@"guanzhu") forState:UIControlStateNormal];
                } else {
                    [self toast:@"关注成功"];
                    [btn setImage:IMAGE_NAMED(@"yiguanzhu") forState:UIControlStateNormal];
                }
            }
        } failure:^(NSError *error) {
            [self toast:error.description];
        }];
    }
}

// 设置头视图的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, kAutoWidth(197));
}

- (NSMutableArray *)videoList {
    if (_videoList == nil) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

//上传背景图
- (void)uploadImage {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改背景图" message:@"选择背景" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"从相机选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    fromCamera.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    UIAlertAction *fromGallery = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:fromGallery];
    [alertController addAction:fromCamera];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *bgImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        bgImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        bgImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,KQiniuToken) parameters:nil success:^(id responseObject) {
        
        NSString *token = responseObject[@"data"][@"res"][@"token"];
         PPLog(@"七牛token = %@",token);
        NSData *imageData = UIImageJPEGRepresentation(bgImage, 0.1f);
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        [upManager putData:imageData key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                      PPLog(@"Qiniu info = %@", info);
//                      PPLog(@"Qiniu resp = %@", resp);
//                      PPLog(@"Qiniu key = %@", key);
                      
                      if (info.ok) {
                          PPLog(@"成功");
                          NSString *imgUrl = NSStringFormat(@"%@%@", kQiniuURLHost, resp[@"key"]);
                          [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kUserUpdata) parameters:@{@"background": imgUrl} success:^(id responseObject) {
                              [self hideLoading];
                              NSLog(@"%@", responseObject);
                              NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
                              
                              if ([code isEqualToString:@"0"]) {
                                  [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
                                  self.headerView.bgImg.image = bgImage;
                                  self.users.background = responseObject[@"data"][@"res"][@"background"];
                                  
                              }
                          } failure:^(NSError *error) {
                              PPLog(@"%@", error);
                          }];
                      } else {
                          PPLog(@"失败");
                      }
                  } option:nil];
        
        //        PPLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
