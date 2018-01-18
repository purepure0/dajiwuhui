//
//  ContactHeaderView.h
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShowDetailBlock)(BOOL isShow);
@interface ContactHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

@property (nonatomic, copy)ShowDetailBlock showBlock;
@property (nonatomic, strong)UIImageView *arrowView;
@property (nonatomic, assign)BOOL isShow;
@property (nonatomic, strong)UILabel *titleLabel;
@end
