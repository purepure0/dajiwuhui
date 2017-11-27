//
//  UIBarButtonItem+SCItem.h
//  CarLifes
//
//  Created by yu on 2017/6/14.
//  Copyright © 2017年 jpas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SCItem)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
