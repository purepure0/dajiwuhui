//
//  TeamNotiListViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface TeamNotiListViewController : BaseViewController
@property (nonatomic, strong)NSArray<NIMSystemNotification *> *notifications;
@end
