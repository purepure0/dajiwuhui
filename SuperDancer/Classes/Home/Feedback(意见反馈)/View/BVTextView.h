//
//  BVTextView.h
//  BuyVegetable
//
//  Created by yushanchang on 16/10/7.
//  Copyright © 2016年 com.yinding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BVTextView : UITextView
/**
 *  占位符
 */
@property (nonatomic, strong) UILabel *placeholderLabel;
/**
 *  字数限制
 */
@property (nonatomic, strong) UILabel *numLabel;

@end
