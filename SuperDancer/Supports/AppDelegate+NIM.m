//
//  AppDelegate+NIM.m
//  SuperDancer
//
//  Created by yu on 2017/12/16.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AppDelegate+NIM.h"

@implementation AppDelegate (NIM)

- (void)setupNIMSDK
{
    //配置额外配置信息 （需要在注册 appkey 前完成)
    //略
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = @"45f097c6ebe072b28422e670ce15824b";
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"DJWHPushDevelopment";
    option.pkCername        = nil;
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //设置上传下载使用http
    NIMServerSetting *setting = [[NIMServerSetting alloc] init];
    setting.httpsEnabled = NO;
    [[NIMSDK sharedSDK] setServerSetting:setting];
    
    NSLog(@"appKey:%@", [[NIMSDK sharedSDK] appKey]);
    //注册自定义消息的解析器
    //    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    //    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
    SDUser *user = [SDUser sharedUser];
    if (user.userId != nil && user.token != nil) {
        NSLog(@"自动登录");
        [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
        [[[NIMSDK sharedSDK] loginManager] autoLogin:user.userId token:user.token];
        
    }
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK] registerWithAppID:appKey cerName:option.apnsCername];
    [self registerPushService];
}

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    NSLog(@"message:%@", messages);
}



- (void)onLogin:(NIMLoginStep)step {
    PPLog(@"STEP:%ld", step);
}

- (void)onAutoLoginFailed:(NSError *)error {
    PPLog(@"自动登录失败:%@", error);
}


#pragma mark -- APNS
//- (void)registerAPNS {
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//
//    }else {
//        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
//    }
//}
//
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"aaaa");
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)registerPushService
{
    if (@available(iOS 11.0, *))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
            {
                NSLog(@"请开启推送功能否则无法收到推送通知");
            }
        }];
    }
    else
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    

}



@end
