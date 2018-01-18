//
//  AddMembersViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^AddFinishedBlock)(void);

@interface AddMembersViewController : BaseViewController
@property (nonatomic, assign)BOOL isCreating;
@property (nonatomic, strong)NSString *teamID;
@property (nonatomic, strong)NIMTeam *team;
@property (nonatomic, strong)NSMutableArray *selectedMembers;
@property (nonatomic, strong)NSMutableArray *teamMemberUserIDs;
@property (nonatomic, copy)AddFinishedBlock finished;


@end
