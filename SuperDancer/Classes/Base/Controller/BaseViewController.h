//
//  BaseViewController.h
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDUser.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "SDRequestManager.h"
#import <MJRefreshNormalHeader.h>
#import <MJRefreshBackNormalFooter.h>

@class YYLabel;

typedef void(^RightItemBlock)(NSInteger index);

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, copy) RightItemBlock block;

@property (nonatomic, strong) YYLabel *badge;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) SDUser *users;

@property (nonatomic, strong) SDRequestManager *requestManager;

@property (nonatomic, strong)MJRefreshNormalHeader *header;

@property (nonatomic, assign)BOOL isFreshing;

@property (nonatomic, strong)MJRefreshBackNormalFooter *footer;

@property (nonatomic, assign)NSInteger page;

/**
 隐藏导航底部黑线
 */
- (void)setNavBarShadowImageHidden:(BOOL)hidden;

/**
 设置状态栏风格

 @param style 状态栏风格
 */
- (void)setStatusBarStyle:(UIStatusBarStyle)style;

/**隐藏导航栏
 */
- (void)hideNavigationBar:(BOOL)hidden
                 animated:(BOOL)animated;

/**导航栏LeftItem文字
 */
- (void)setLeftItemTitle:(NSString *)title
                  action:(SEL)action;

/**导航栏LeftItem图片
 */
- (void)setLeftImageNamed:(NSString *)name
                   action:(SEL)action;

/**导航栏RightItem文字
 */
- (void)setRightItemTitle:(NSString *)title
                   action:(SEL)action;

- (void)setRightItemTitle:(NSString *)title
               titleColor:(UIColor *)color
                   action:(SEL)action;

/**导航栏RightItem图片
 */
- (void)setRightImageNamed:(NSString *)name
                    action:(SEL)action;
/**导航栏RightItem图片、文字
 */
- (void)setRightImageNamed:(NSString *)name
                     title:(NSString *)title
                    action:(SEL)action;

/**导航栏RightItem多个图片
 */
- (void)setupRightItems:(NSArray *)images;

/**设置titleView图片
 */
- (void)setTitleView:(NSString *)imageName;

/**设置默认navigationbar status bar 黑色
 */
- (void)setDefaultNavigationBar;

/**设置透明navigationbar status bar 黑色
 */
- (void)setClearNavigationBar;

/**设置返回按钮
 */
- (void)setBackItem;
- (void)setBackItemAction:(SEL)sel;
- (void)setBackItem:(NSString *)title
             action:(SEL)sel;
/**设置导航栏
 */
- (void)setNavigationBarBackgroundImage:(UIImage *)image
                              tintColor:(UIColor *)tintColor
                              textColor:(UIColor *)textColor
                         statusBarStyle:(UIStatusBarStyle)style;

/**push不隐藏tabbar
 */
- (void)pushController:(BaseViewController *)controller;
/**push隐藏tabbar
 */
- (void)hideBottomBarPush:(BaseViewController *)controller;

/**隐藏右侧导航栏徽标
 */
- (void)hideItemBadge;

/**设置详情徽标
 */
- (void)setTreasureDetailBadge:(NSInteger)value;

/**导航栏渐变
 */
//- (void)setNavigationBarCover:(UIScrollView *)scrollView
//                        color:(UIColor *)color;

/**更新请求header */
- (void)updateHttpHeader;
- (NSString *)jsonToString:(id)data;
#pragma mark - toast -

- (void)showLoading;
- (void)hideLoading;

- (void)toast:(NSString *)text;
- (void)success:(NSString *)text;
- (void)failure:(NSString *)text;

@end
