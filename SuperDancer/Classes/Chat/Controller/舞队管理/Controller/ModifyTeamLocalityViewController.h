//
//  ModifyTeamLocalityViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^TeamAddressResult)(NSString *address);
@interface ModifyTeamLocalityViewController : BaseViewController

@property (nonatomic, assign)BOOL isCreating;//区分:创建舞队信息/编辑舞队信息

@property (nonatomic, copy)TeamAddressResult addressBlock;

@property (nonatomic, strong) NIMTeam *team;

@property (nonatomic, copy) NSString *locality;

@end
