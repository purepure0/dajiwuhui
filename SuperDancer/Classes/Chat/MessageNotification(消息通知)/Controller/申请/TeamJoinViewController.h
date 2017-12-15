//
//  TeamJoinViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"
typedef enum : NSUInteger {
    JoinStateWillJoin,
    JoinStateJoined,
    JoinStateRefused
} JoinState;
@interface TeamJoinViewController : BaseViewController

- (instancetype)initWithJoinState:(JoinState)joinSate;

@end


