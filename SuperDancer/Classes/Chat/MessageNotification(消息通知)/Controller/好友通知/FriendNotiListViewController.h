//
//  FriendNotiListViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendNotiListViewController : BaseViewController
@property (nonatomic, strong)NSArray<NIMSystemNotification *> *notifications;
@end
