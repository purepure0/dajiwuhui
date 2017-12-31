//
//  GroupNoticeViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupNoticeViewController : BaseViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, assign) BOOL canPublishAnnouncement;

@end
