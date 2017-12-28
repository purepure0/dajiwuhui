//
//  TeamSessionViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <NIMKit/NIMKit.h>

@interface TeamSessionViewController : NIMSessionViewController
@property (nonatomic, strong)NIMTeam *team;
@property (nonatomic, copy)NSString *teamID;
@end
