//
//  DownloadViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DownloadViewController.h"
#import <WMPageController.h>

#import "MovieDownloadViewController.h"
#import "MusicDownloadViewController.h"

@interface DownloadViewController ()<WMPageControllerDelegate, WMPageControllerDataSource, WMMenuViewDelegate>

@property (nonatomic, strong) WMPageController *pageController;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPageController];
}

- (void)initPageController
{
    self.pageController = [[WMPageController alloc] initWithViewControllerClasses:@[[MovieDownloadViewController class],[MusicDownloadViewController class]] andTheirTitles:@[@"视频", @"音乐"]];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.titleSizeNormal = 16;
    self.pageController.titleSizeSelected = 16;
    self.pageController.titleColorNormal = kColorRGB(33, 33, 33);
    self.pageController.titleColorSelected = kColorRGB(140, 50, 180);
    self.pageController.scrollEnable = NO;
    self.pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100);
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
    
    self.pageController.menuView.backgroundColor = [UIColor whiteColor];
    [self.pageController.menuView setStyle:WMMenuViewStyleLine];
    [self.pageController.menuView setLayoutMode:WMMenuViewLayoutModeCenter];
    self.pageController.menuView.progressWidths = @[@(40),@(40)];
    self.pageController.menuView.progressViewIsNaughty = YES;
    self.pageController.menuView.lineColor = kColorRGB(140, 50, 180);
    self.pageController.menuView.contentMargin = 20;
    self.navigationItem.titleView = self.pageController.menuView;
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kScreenWidth, 44);
}

//- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
//    return pageController.view.frame;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
