//
//  TeamSessionRemoteHistoryViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamSessionViewController.h"

@interface TeamSessionRemoteHistoryViewController : NIMSessionViewController

@property (nonatomic, strong) NIMTeam *team;

@end


@interface RemoteSessionConfig : NSObject<NIMSessionConfig>

@end

