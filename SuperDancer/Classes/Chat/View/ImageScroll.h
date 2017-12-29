//
//  ImageScroll.h
//  NEKA
//
//  Created by ma c on 16/4/27.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DismissViewCtrlBlock)(void);
@interface ImageScroll : UIScrollView
@property (nonatomic, copy)DismissViewCtrlBlock dismissBlock;

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)url;
- (void)goBackToInitial;
@end
