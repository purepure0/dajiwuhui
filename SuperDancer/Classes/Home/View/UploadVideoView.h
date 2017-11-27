//
//  UploadVideoView.h
//  SuperDancer
//
//  Created by yu on 2017/10/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleBlock)(void);

@interface UploadVideoView : UIView

@property (nonatomic, copy) HandleBlock exitBlock;

@property (nonatomic, copy) HandleBlock shootBlock;

@property (nonatomic, copy) HandleBlock chooseBlock;

@end
