//
//  SuperDancerConfig.h
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#ifndef SuperDancerConfig_h
#define SuperDancerConfig_h


#ifdef DEBUG
#define PPLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define PPLog(...)
#endif

#define SYSTEM_FONT(_fontsize_)  [UIFont systemFontOfSize:_fontsize_]
#define Font_NAME_SIZE(_fontname_,_fontsize_) [UIFont fontWithName:_fontname_ size:_fontsize_]
#define IMAGE_NAMED(_imageName_) [UIImage imageNamed:_imageName_]
#define NIB_NAMED(nibName) [UINib nibWithNibName:nibName bundle:nil]
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


#define kKeyWindow [UIApplication sharedApplication].keyWindow

// 紫色
#define kBaseColor       [UIColor colorWithHexString:@"#8C32B4"]
// 文字黑
#define kTextBlackColor  [UIColor colorWithHexString:@"#212121"]
// 文字灰
#define kTextGrayColor   [UIColor colorWithHexString:@"#BDBDBD"]
// 线条灰
#define kLineColor       [UIColor colorWithHexString:@"#D9DDE0"]
// 背景灰
#define kBackgroundColor [UIColor colorWithHexString:@"#F5F5F5"]
// RGB颜色
#define kColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
// Hex颜色
#define kColorHexStr(HexString) [UIColor colorWithHexString:HexString]


// 物理尺寸
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// 自适应宽高(以6/6s为基准)
#define kAutoWidth(w) (kScreenWidth/375) * (w)
#define kAutoHeight(h) (kScreenHeight/667) * (h)
//导航栏与状态栏高度和
#define kNAVHeight (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
//tabbar高度
#define ktabbarHeight [[UITabBarController alloc] init].tabBar.frame.size.height
//判断是否是iphonex
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* SuperDancerConfig_h */
