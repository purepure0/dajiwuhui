//
//  SDHomeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDHomeViewController.h"

#import "LocalDanceViewController.h"
#import "SquareDanceViewController.h"
#import "ChildDanceViewController.h"
#import "RecommendViewController.h"

#import "WMPageController.h"

#import "UploadVideoView.h"

#import "KLCPopup.h"

#import "SDNavigationController.h"
#import "LoginViewController.h"

#import "MovieDownloadViewController.h"
#import "BrowsingHistoryViewController.h"
#import "PersonalCenterViewController.h"
#import "MyCollectionViewController.h"
#import "MsgCenterViewController.h"
#import "CitySelectViewController.h"
#import "UserAgreeViewController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "UploadVideoViewController.h"

@interface SDHomeViewController ()<WMPageControllerDelegate,WMPageControllerDataSource,WMMenuViewDelegate>

@property (nonatomic, strong) WMPageController *pageController;

@property (nonatomic, strong) KLCPopup *popup;

@property (nonatomic, strong) KLCPopup *popup_s;

@property (nonatomic, strong) UploadVideoView *uploadVideoView;

@property (nonatomic, strong) UIButton *leftItemBtn;

@end

@implementation SDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleView:@"nav_logo"];
    
    [self initPageController];
    //注：一期不加视频上传功能
//    [self setupUploadBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDistrict) name:@"ChangeDistrict" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavBarShadowImageHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNavBarShadowImageHidden:NO];
}

- (void)setupUploadBtn
{
    UIButton *uploadBtn = [[UIButton alloc] init];
    [uploadBtn setImage:IMAGE_NAMED(@"video_upload") forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
    
    uploadBtn.sd_layout
    .rightSpaceToView(self.view, 33)
    .bottomSpaceToView(self.view, 33)
    .widthIs(75)
    .heightEqualToWidth();
}

- (void)initPageController
{
    self.pageController = [[WMPageController alloc] initWithViewControllerClasses:@[[RecommendViewController class],[SquareDanceViewController class],[ChildDanceViewController class],[LocalDanceViewController class]] andTheirTitles:@[@"推荐",@"广场舞",@"儿童舞",@"同城"]];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.titleSizeNormal = 14;
    self.pageController.titleSizeSelected = 16;
    self.pageController.titleColorNormal = [kColorHexStr(@"#212121") colorWithAlphaComponent:0.8];
    self.pageController.titleColorSelected = kColorHexStr(@"#212121");

    self.pageController.view.frame = self.view.frame;
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36.5)];
    bgView.backgroundColor = kColorHexStr(@"#E7E7E7");
    [self.view addSubview:bgView];
    self.pageController.menuView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:self.pageController.menuView];
}

#pragma mark -上传视频
- (void)uploadVideoAction {
    PPLog(@"视频上传");
    [self.popup_s showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

#pragma mark -切换城市
- (void)changeAreaAction
{
    PPLog(@"同城");
    CitySelectViewController *citySelect = [[CitySelectViewController alloc] init];
    [self.navigationController pushViewController:citySelect animated:YES];
    
}

#pragma mark - Datasource & Delegate

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kScreenWidth, 36);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    if ([viewController isKindOfClass:[LocalDanceViewController class]]) {
        if (self.users.districtSelected) {
            [self setRightImageNamed:@"location" title:self.users.districtSelected action:@selector(changeAreaAction)];
        }else {
            [self setRightImageNamed:@"location" title:self.users.districtLocation action:@selector(changeAreaAction)];
        }
        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)updateDistrict {
    if (self.users.districtSelected) {
        [self setRightImageNamed:@"location" title:self.users.districtSelected action:@selector(changeAreaAction)];
    } else {
        [self setRightImageNamed:@"location" title:self.users.districtLocation action:@selector(changeAreaAction)];
    }
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setupUploadVideoView];
        [self setupPopupView_s];
    }
    return self;
}

- (void)setupUploadVideoView
{
    if (self.uploadVideoView == nil) {
        self.uploadVideoView = [[[NSBundle mainBundle]loadNibNamed:@"UploadVideoView" owner:self options:nil] lastObject];
        self.uploadVideoView.size_sd = CGSizeMake(300, 180);
        
        @weakify(self);
        self.uploadVideoView.exitBlock = ^{
            @strongify(self);
            [self.popup_s dismiss:YES];
        };
        
        self.uploadVideoView.shootBlock = ^{
            @strongify(self);
            [self.popup_s dismiss:YES];
            PPLog(@"新拍");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UploadVideoViewController *recordVideo = [[UploadVideoViewController alloc] init];
                recordVideo.soureType = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController pushViewController:recordVideo animated:YES];
            }else {
                [MBProgressHUD showError:@"相机未授权或不可用" toView:self.view];
            }
            
        };
        
        self.uploadVideoView.chooseBlock = ^{
            @strongify(self);
            [self.popup_s dismiss:YES];
            PPLog(@"相册选");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UploadVideoViewController *selectVideo = [[UploadVideoViewController alloc] init];
                selectVideo.soureType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:selectVideo animated:YES];
            }else {
                [MBProgressHUD showError:@"相机未授权或不可用" toView:self.view];
            }
        };
    }
}

- (void)setupPopupView_s {
    if (self.popup_s == nil) {
        self.popup_s = [KLCPopup popupWithContentView:self.uploadVideoView
                                             showType:KLCPopupShowTypeBounceInFromTop
                                          dismissType:KLCPopupDismissTypeBounceOutToBottom
                                             maskType:KLCPopupMaskTypeDimmed
                             dismissOnBackgroundTouch:YES
                                dismissOnContentTouch:NO];
    }
}



@end
