//
//  ApplyMessageListCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMNotificationModel.h"
@interface ApplyMessageListCell : UITableViewCell<IMNotificationModelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;


- (void)updateCellWithData:(NSDictionary *)data;

@property (nonatomic, strong)IMNotificationModel *model;

- (void)updateCellWithModel:(IMNotificationModel *)model;


@end
