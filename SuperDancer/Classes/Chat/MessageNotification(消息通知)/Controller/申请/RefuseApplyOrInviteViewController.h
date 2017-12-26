//
//  RefuseApplyViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"
#import "IMNotificationModel.h"
@interface RefuseApplyOrInviteViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *wordNumberLabel;
@property (nonatomic, strong)IMNotificationModel *model;
@end
