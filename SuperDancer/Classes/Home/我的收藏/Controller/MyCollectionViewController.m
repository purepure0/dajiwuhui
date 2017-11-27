//
//  MyCollectionViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MyCollectionViewController.h"
#import <WMPageController.h>
#import "CollectionVideoViewController.h"
#import "CollectionDancersViewController.h"

@interface MyCollectionViewController ()<WMPageControllerDelegate, WMPageControllerDataSource, WMMenuViewDelegate>

@property (nonatomic, strong) WMPageController *pageController;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPageController];
}

- (void)initPageController
{
    
    self.pageController = [[WMPageController alloc] initWithViewControllerClasses:@[[CollectionVideoViewController class],[CollectionDancersViewController class]] andTheirTitles:@[@"视频", @"舞者"]];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.titleSizeNormal = 16;
    self.pageController.titleSizeSelected = 16;
    self.pageController.titleColorNormal = kColorRGB(33, 33, 33);
    self.pageController.titleColorSelected = kColorRGB(140, 50, 180);

    self.pageController.view.frame = self.view.frame;
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];

    self.pageController.menuView.backgroundColor = [UIColor whiteColor];
    [self.pageController.menuView setStyle:WMMenuViewStyleLine];
    [self.pageController.menuView setLayoutMode:WMMenuViewLayoutModeCenter];
    self.pageController.menuView.progressWidths = @[@(40),@(40)];
    self.pageController.menuView.progressViewIsNaughty = YES;
    self.pageController.menuView.lineColor = kColorRGB(140, 50, 180);
    self.pageController.menuView.contentMargin = 20;
//    [self.pageController.menuView.superview removeFromSuperview];
    self.navigationItem.titleView = self.pageController.menuView;
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kScreenWidth, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return pageController.view.frame;
}

- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    PPLog(@"currentIndex == %ld",currentIndex);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
//    if ([viewController isKindOfClass:[LocalDanceViewController class]]) {
//        [self setRightImageNamed:@"location" title:@"牡丹区" action:@selector(changeAreaAction)];
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
