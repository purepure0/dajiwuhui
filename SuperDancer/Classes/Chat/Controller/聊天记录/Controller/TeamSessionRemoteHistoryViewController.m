//
//  TeamSessionRemoteHistoryViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamSessionRemoteHistoryViewController.h"
#import <NIMCustomLeftBarView.h>
#import "TeamInfoViewController.h"
#import "TeamMemmberInfoViewController.h"
#import "ChatImageViewController.h"
#import "ChatVideoViewController.h"
#import "ChatLocationViewController.h"
#import "XLPhotoBrowser.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface TeamSessionRemoteHistoryViewController ()

@property (nonatomic,strong) RemoteSessionConfig *config;

@end

@implementation TeamSessionRemoteHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftBarView.userInteractionEnabled = YES;
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back_black"]];
    [leftBarView addSubview:img];
    [leftBarView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype) initWithSession:(NIMSession *)session{
    self = [super initWithSession:session];
    if (self) {
    }
    return self;
}

- (NSString *)sessionTitle{
    return @"聊天记录";
}

- (id<NIMSessionConfig>)sessionConfig {
    return [RemoteSessionConfig new];
}

///////////////////////////////////////

- (BOOL)onTapAvatar:(NSString *)userId {
    NSLog(@"点击头像：%@", userId);
    TeamMemmberInfoViewController *memberInfo = [[TeamMemmberInfoViewController alloc] init];
    memberInfo.userId = userId;
    memberInfo.team = self.team;
    [self.navigationController pushViewController:memberInfo animated:YES];
    return YES;
}

- (BOOL)onTapCell:(NIMKitEvent *)event {
    BOOL handled = [super onTapCell:event];
    
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent]) {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    
    return handled;
}

- (void)showImage:(NIMMessage *)message
{
    NSLog(@"图片");
    NIMImageObject *object = message.messageObject;
//    ChatImageViewController *showPic = [[ChatImageViewController alloc] initWithImageUrl:[object url]];
//    [self presentViewController:showPic animated:YES completion:nil];
    [XLPhotoBrowser showPhotoBrowserWithImages:@[object.url] currentImageIndex:0];
}

- (void)showVideo:(NIMMessage *)message
{
    NSLog(@"视频");
    NIMVideoObject *object = message.messageObject;
    ChatVideoViewController *playVieo = [[ChatVideoViewController alloc] init];
    playVieo.videoObj = object;
    [self.navigationController pushViewController:playVieo animated:YES];
}

- (void)showLocation:(NIMMessage *)message
{
    NSLog(@"定位");
    
}

- (void)showFile:(NIMMessage *)message
{
    NSLog(@"文件");
}

- (void)showCustom:(NIMMessage *)message
{
    //普通的自定义消息点击事件可以在这里做哦~
}



- (void)openSafari:(NSString *)link
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:link];
    if (components)
    {
        if (!components.scheme)
        {
            //默认添加 http
            components.scheme = @"http";
        }
        [[UIApplication sharedApplication] openURL:[components URL]];
    }
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

@end



@implementation RemoteSessionConfig

- (BOOL)disableInputView{
    return YES;
}

//云消息不支持音频轮播
- (BOOL)disableAutoPlayAudio
{
    return YES;
}

//云消息不显示已读
- (BOOL)shouldHandleReceipt{
    return NO;
}

- (BOOL)disableReceiveNewMessages
{
    return YES;
}

@end


