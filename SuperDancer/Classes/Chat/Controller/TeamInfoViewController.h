//
//  TeamInfoViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface TeamInfoViewController : BaseViewController

@property (nonatomic, copy)NSString *teamID;
@property (nonatomic, strong)NIMTeam *team;
@property (nonatomic, assign)BOOL isTeamOwner; //是否是群管理员

@end
