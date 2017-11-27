//
//  MovePlayerViewController.h
//  SuperDancer
//
//  Created by yu on 2017/10/7.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoListModel.h"

@interface MovePlayerViewController : BaseViewController

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, copy) NSString *vid;

@end
