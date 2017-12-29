//
//  FriendInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "TeamJoinCell.h"
#import "FriendChatViewController.h"

@interface FriendInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isMe;

@property (nonatomic, strong) NIMUser *user;

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMe = [self.users.userId isEqualToString:self.userId];
    PPLog(@"MMMMMMM=%@",self.isMe ? @"自己":@"别人");
    
    self.user = [[NIMSDK sharedSDK].userManager userInfo:self.userId];
    PPLog(@"userInfo == %@",self.user.userInfo);
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    if (indexPath.section == 0) {
        index = 0;
    }else if (indexPath.section == 2) {
        index = 2;
    }else {
        index = 1;
    }
    TeamJoinCell *cell = [TeamJoinCell initWithTableView:tableView andIndex:index];
    if (indexPath.section == 0) {
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:self.user.userInfo.avatarUrl] placeholder:IMAGE_NAMED(@"placeholder_img")];
        cell.nicknameLabel.text = self.user.userInfo.nickName;
        cell.cityLabel.text = @"未填写";
        [cell.qcodeBtn setHidden:YES];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"手机号码";
            cell.rightLabel.text = self.user.userInfo.mobile;
        }else {
            cell.leftLabel.text = @"所在地区";
            cell.rightLabel.text = @"未填写";
        }
        [cell showRigthArrow:NO];
    }else if (indexPath.section == 2) {
        cell.topLabel.text = @"个人介绍";
        cell.bottomLabel.text = self.user.userInfo.sign;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (!self.isMe) {
            UIView *bgView = [[UIView alloc] init];
            
            UIButton *chatBtn = [[UIButton alloc] init];
            [chatBtn setTitle:@"聊天" forState:UIControlStateNormal];
            [chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            chatBtn.backgroundColor = kColorRGB(44, 145, 247);
            [chatBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:chatBtn];
            
            UIButton *delBtn = [[UIButton alloc] init];
            [delBtn setTitle:@"删除好友" forState:UIControlStateNormal];
            [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            delBtn.backgroundColor = kBaseColor;
            [delBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:delBtn];
            
            chatBtn.sd_layout
            .leftSpaceToView(bgView, 15)
            .topSpaceToView(bgView, 30)
            .rightSpaceToView(bgView, 15)
            .heightIs(45);
            
            delBtn.sd_layout
            .leftEqualToView(chatBtn)
            .rightEqualToView(chatBtn)
            .topSpaceToView(chatBtn, 15)
            .heightIs(45);
            
            chatBtn.sd_cornerRadius = @(5);
            delBtn.sd_cornerRadius = @(5);
            
            return bgView;
        }
    }
    return nil;
}

- (void)chatAction {
    UINavigationController *nav = self.navigationController;
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    FriendChatViewController *fc = [[FriendChatViewController alloc] initWithSession:session];
    [nav pushViewController:fc animated:YES];
    UIViewController *root = nav.viewControllers[0];
    UIViewController *root1 = nav.viewControllers[1];
    nav.viewControllers = @[root,root1,fc];
}

- (void)deleteAction
{
    UIAlertController *alertContrller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该操作无法撤销,是否删除该好友?" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.hud show:YES];
        [[NIMSDK sharedSDK].userManager deleteFriend:self.userId completion:^(NSError * _Nullable error) {
            PPLog(@"delete friend error == %@",error.description);
            if (!error) {
                [self.hud hide:YES];
                [self toast:@"删除成功"];
                UIViewController *back = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:back animated:YES];
            }else {
                [self toast:@"删除失败"];
            }
        }];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertContrller addAction:deleteAction];
    [alertContrller addAction:confirmAction];
    [self presentViewController:alertContrller animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ? 150:0.001;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return !section ? 0.01:10;
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return YES;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
