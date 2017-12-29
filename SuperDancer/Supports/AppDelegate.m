//
//  AppDelegate.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AppDelegate.h"
#import "SDNavigationController.h"
#import "SDHomeViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialWechatHandler.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SDUser.h"
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import "SDTabBarController.h"
//#import <Bugtags/Bugtags.h>

#define kAMapApiKey @"2b9d644cfa86764d460dff45bf4f7842"
#define JPushAppKey @"fdf767381c7291e4b8a98a7b"
//app key :45f097c6ebe072b28422e670ce15824b
//App Secret :745b8f862ca9
@interface AppDelegate ()<AMapLocationManagerDelegate, JPUSHRegisterDelegate, NIMLoginManagerDelegate, NIMLoginManager, NIMChatManagerDelegate, NIMSystemNotificationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ///<1>友盟.
    [self configureUMeng];
    ///<2>高德.
    [self configureAMapService];
    ///<3>定位.
    [self initLocationManager];
    ///<4>极光推送
//    [self configureJPushWithLaunchOptions:launchOptions];
    ///<5>bugtags测试工具
//    [Bugtags startWithAppKey:@"08202dec433c4ed124ec3d36ee834d3e" invocationEvent:BTGInvocationEventBubble];
    ///<6>网易IM
    [self setupNIMSDK];
    [self registerPushService];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[SDTabBarController alloc] init];
    ///<7>.适配iOS 11
    [self configureIos11];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureAMapService {
    [AMapServices sharedServices].apiKey = kAMapApiKey;
    [AMapServices sharedServices].enableHTTPS = YES;
}

- (void)configureUMeng {
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppkey];
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:nil];
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID appSecret:QQAppKEY redirectURL:nil];
    
}

- (void)configureIos11 {
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)initLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 5;
    self.locationManager.reGeocodeTimeout = 5;
    [self startUpdateLocation];
}

- (void)startUpdateLocation
{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"定位失败");
            [SDUser sharedUser].provinceLocation = @"山东省";
            [SDUser sharedUser].cityLocation = @"菏泽市";
            [SDUser sharedUser].districtLocation = @"牡丹区";
        }
        
        if (regeocode)
        {
            NSLog(@"定位成功>>>%@%@%@",regeocode.province,regeocode.city,regeocode.district);
            [SDUser sharedUser].provinceLocation = regeocode.province;
            [SDUser sharedUser].cityLocation = regeocode.city;
            [SDUser sharedUser].districtLocation = regeocode.district;
            NSLog(@"%@--%@--%@", [SDUser sharedUser].provinceLocation,[SDUser sharedUser].cityLocation, [SDUser sharedUser].districtLocation);
        }
        
        if (location)
        {
            [SDUser sharedUser].latLocation = NSStringFormat(@"%lf",location.coordinate.latitude);
            [SDUser sharedUser].lonLocation = NSStringFormat(@"%lf",location.coordinate.longitude);
        }
    }];
}

// 极光推送
/*
- (void)configureJPushWithLaunchOptions:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:@"APP Store" apsForProduction:NO];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        } else {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
*/
//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
////iOS8.0~10.0
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService handleRemoteNotification:userInfo];
//    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        NSLog(@"%s", __func__);
//        if ([JPUSHService setBadge:0]) {
//            NSLog(@"badge设置成功");
//        }
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    }
//
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//
////iOS10.0之后
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//// 程序关闭后, 通过点击推送弹出的通知
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        if ([JPUSHService setBadge:0]) {
//            NSLog(@"badge设置成功");
//        }
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//        NSLog(@"%s: \n%@", __func__, userInfo);
//    }else {
//        NSLog(@"本地通知%@", userInfo);
//    }
//    completionHandler();
//}
//
//// 当程序在前台时, 收到推送的通知
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    NSDictionary *userInfo = notification.request.content.userInfo;
//    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"%s: \n%@", __func__, userInfo);
//    }else {
//        NSLog(@"本地通知%@", userInfo);
//    }
//    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
//}
//
//#endif


- (void)setupNIMSDK
{
    //配置额外配置信息 （需要在注册 appkey 前完成)
    //略
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = @"45f097c6ebe072b28422e670ce15824b";
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"DJWHPushDevelopment";
    option.pkCername        = nil;
    [[NIMSDK sharedSDK] registerWithOption:option];
    
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
}

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    NSLog(@"message:%@", messages);
}



- (void)onLogin:(NIMLoginStep)step {
    PPLog(@"STEP:%ld", step);
    if (step == 5) {
        NSLog(@"%@", [[[NIMSDK sharedSDK] teamManager] allMyTeams]);
    }
}

- (void)onAutoLoginFailed:(NSError *)error {
    PPLog(@"自动登录失败:%@", error);
}



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
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
}


- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadCount];
}




















- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
