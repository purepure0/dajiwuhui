//
//  UIButton+Block.h
//  WA
//
//  Created by Haitao on 2015/2/2.
//  Copyright © 2015年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>

typedef void (^ActionBlock)(void);

@interface UIButton (Block)

@property (nonatomic, copy) NSString *Type;

@property (readonly) NSMutableDictionary *event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;


@end
