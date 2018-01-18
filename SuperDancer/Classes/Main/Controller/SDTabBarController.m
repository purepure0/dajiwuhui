//
//  SDTabBarController.m
//  SuperDancer
//
//  Created by yu on 2017/11/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDTabBarController.h"

#import "SDNavigationController.h"
#import "SDHomeViewController.h"
#import "SDChatViewController.h"
#import "SDChatPageViewController.h"
#import "SDMineViewController.h"
#import "UIImage+CLImage.h"

@interface SDTabBarController ()

@end

@implementation SDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewControllers];
    self.tabBar.translucent = YES;
}

- (void)setupAllChildViewControllers {
    
    SDHomeViewController *home = [[SDHomeViewController alloc] init];
    [self setupChildViewController:home image:[UIImage imageNamed:@"wd_tab_btnl_video_nor"] selectImage:[UIImage imageWithOriginalName:@"wd_tab_btnl_video_sel"] title:@"视频"];
    
    SDChatPageViewController *chat = [[SDChatPageViewController alloc] init];
    [self setupChildViewController:chat image:[UIImage imageNamed:@"wd_tab_btnl_chat_nor"] selectImage:[UIImage imageWithOriginalName:@"wd_tab_btnl_chat_sel"] title:@"舞队"];
    
    SDMineViewController *mine = [[SDMineViewController alloc] init];
    [self setupChildViewController:mine image:[UIImage imageNamed:@"wd_tab_btn_my_nor"] selectImage:[UIImage imageWithOriginalName:@"wd_tab_btn_my_sel"] title:@"我的"];
}

/**
 添加子控制器
 
 @param viewController 子控制器
 @param image 默认图片
 @param selectImage 选中图片
 @param title item的标题
 */
- (void)setupChildViewController:(UIViewController *)viewController image:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title{
    
    viewController.title = title;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectImage;
    
    SDNavigationController *nav = [[SDNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

/**
 设置TabbarItem的主题
 */
+ (void)initialize {
    
    UITabBarItem *items = [UITabBarItem appearance];
        [items setTitlePositionAdjustment:UIOffsetMake(0, -2.0)];
    
    [items setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:10]}
                         forState:UIControlStateNormal];
    [items setTitleTextAttributes:@{NSForegroundColorAttributeName:kBaseColor,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
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
