//
//  DancerListCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DancerModel.h"

typedef void(^AttentionBlock)(DancerModel *model);
@interface DancerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *districtBtn;



@property (nonatomic, strong) DancerModel *model;
@property (nonatomic, copy) AttentionBlock attentionBlock;


@end
