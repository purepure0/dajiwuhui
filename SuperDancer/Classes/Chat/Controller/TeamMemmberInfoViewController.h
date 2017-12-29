//
//  TeamMemmberInfoViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface TeamMemmberInfoViewController : BaseViewController

// 群成员Id
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NIMTeam *team;

@end
