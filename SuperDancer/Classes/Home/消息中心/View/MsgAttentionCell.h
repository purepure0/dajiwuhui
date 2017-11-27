//
//  MsgAttentionCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgAttentionModel.h"

@interface MsgAttentionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *whoAttentionLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) MsgAttentionModel *model;

@end
