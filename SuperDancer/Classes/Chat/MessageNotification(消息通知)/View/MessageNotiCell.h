//
//  MessageNotiCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSystemNotificationClassifier.h"
#import "IMNotificationModel.h"
@interface MessageNotiCell : UITableViewCell<IMNotificationModelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;

@property (nonatomic, strong)IMNotificationModel *model;

- (void)updateCellWithData:(NSDictionary *)dic;
- (void)updateCellWithData:(NSDictionary *)dic andNotifications:(NSArray <NIMSystemNotification *> *)notifications;
@end
