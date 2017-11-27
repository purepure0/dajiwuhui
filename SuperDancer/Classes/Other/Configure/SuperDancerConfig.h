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
#define kBaseColor [UIColor colorWithHexString:@"#8C32B4"]
#define kDefaultColor    [UIColor colorWithHexString:@"#212121"]
#define kLineColor       [UIColor colorWithHexString:@"#D9DDE0"]
#define kTextGrayColor   [UIColor colorWithHexString:@"#BDBDBD"]
#define kBackgroundColor [UIColor colorWithHexString:@"#F9F9F9"]

#define kColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kColorHexStr(_HexString_) [UIColor colorWithHexString:_HexString_]

// 屏幕宽高
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// 自适应宽高(以6/6s为基准)
#define kAutoWidth(w) (kScreenWidth/375) * (w)
#define kAutoHeight(h) (kScreenHeight/667) * (h)

#endif /* SuperDancerConfig_h */
