//
//  UIBarButtonItem+SCItem.m
//  CarLifes
//
//  Created by yu on 2017/6/14.
//  Copyright © 2017年 jpas. All rights reserved.
//

#import "UIBarButtonItem+SCItem.h"

@implementation UIBarButtonItem (SCItem)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
