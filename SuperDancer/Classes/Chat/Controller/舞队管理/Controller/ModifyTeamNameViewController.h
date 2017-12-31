//
//  ModifyTeamNameViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/31.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyTeamNameViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NIMTeam *team;

@end
