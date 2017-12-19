//
//  AddMembersViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^AddFinishedBlock)();
@interface AddMembersViewController : BaseViewController

@property (nonatomic, strong)NSMutableArray *members;
@property (nonatomic, copy)AddFinishedBlock finished;


@end
