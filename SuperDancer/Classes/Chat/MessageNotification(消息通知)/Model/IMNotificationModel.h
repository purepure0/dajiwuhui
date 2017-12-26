//
//  IMNotificationModel.h
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMNotificationModelDelegate <NSObject>
- (void)updateUIWithModel;
@end


@interface IMNotificationModel : NSObject


@property (nonatomic, strong)NIMSystemNotification *notification; //系统消息
@property (nonatomic, copy)NSString *sourceName; //发起者
@property (nonatomic, copy)NSString *targetName; //接收者
@property (nonatomic, copy)NSString *sourceAvatarURL; //发起者头像
@property (nonatomic, copy)NSString *message; //消息
@property (nonatomic, copy)NSString *dateStr;
@property (nonatomic, copy)NSString *postscript; //附言、验证消息


//好友请求--通知类型
@property (nonatomic, assign)NIMUserOperation operation;

- (instancetype)initWithSystemNotification:(NIMSystemNotification *)notication;
@property (nonatomic, weak) id<IMNotificationModelDelegate> delegate;

@end
