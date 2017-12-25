//
//  TeamSessionRemoteHistoryViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamSessionRemoteHistoryViewController.h"
#import <NIMCustomLeftBarView.h>
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

- (void)back {
    PPLog(@"返回");
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


