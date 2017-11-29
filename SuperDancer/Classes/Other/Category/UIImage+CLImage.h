//
//  UIImage+CLImage.h
//  CarLifes
//
//  Created by yu on 2017/6/14.
//  Copyright © 2017年 jpas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CLImage)

+ (instancetype)imageWithOriginalName:(NSString *)imageName;
+ (instancetype)imageWithStretchableName:(NSString *)imageName;
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
