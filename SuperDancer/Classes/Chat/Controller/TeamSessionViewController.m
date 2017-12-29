//
//  TeamSessionViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamSessionViewController.h"
#import <NIMCustomLeftBarView.h>
#import "TeamInfoViewController.h"
#import "TeamMemmberInfoViewController.h"
#import "ChatImageViewController.h"
#import "ChatVideoViewController.h"
#import "ChatLocationViewController.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
@interface TeamSessionViewController ()

@end

@implementation TeamSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCustomNav];
}

- (void)setupCustomNav {
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    

    NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftBarView.badgeView = nil;
    leftBarView.userInteractionEnabled = YES;
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back_black"]];
    [leftBarView addSubview:img];
    [leftBarView addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightBtn addTarget:self action:@selector(teamInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}


- (void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)teamInfo:(UIButton *)btn {
    NSLog(@"teamInfo");
    TeamInfoViewController *teamInfo = [[TeamInfoViewController alloc] init];
    teamInfo.teamID = _teamID;
    teamInfo.team = _team;
    [self.navigationController pushViewController:teamInfo animated:YES];
    
}
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
    ChatImageViewController *showPic = [[ChatImageViewController alloc] initWithImageUrl:[object url]];
    [self presentViewController:showPic animated:YES completion:nil];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
