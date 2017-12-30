//
//  NearDancerInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "NearDancerInfoViewController.h"
#import "TeamJoinCell.h"
@interface NearDancerInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL isMe; //是否是自己
@property (nonatomic, assign) BOOL isMyFriend; //是否是好友
@property (nonatomic, strong) NIMUser *user;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NIMUser *owner;
@property (nonatomic, copy) NSString *ownername;

@end

@implementation NearDancerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    self.isMe = [self.userId isEqualToString:self.users.userId];
    self.isMyFriend = [[NIMSDK sharedSDK].userManager isMyFriend:self.userId];
    
    self.user = [[NIMSDK sharedSDK].userManager userInfo:self.userId];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if (!indexPath.section) {
        index = 0;
    }else if (indexPath.section == 2) {
        index = 2;
    }else {
        index = 1;
    }
    TeamJoinCell *cell = [TeamJoinCell initWithTableView:tableView andIndex:index];
    if (!indexPath.section) {
        
            [cell.iconImageView setImageWithURL:[NSURL URLWithString:self.user.userInfo.avatarUrl] placeholder:IMAGE_NAMED(@"placeholder_img")];
            cell.nicknameLabel.text = self.user.userInfo.nickName.length ? self.user.userInfo.nickName:@"未设置";
            cell.cityLabel.text = @"未设置";
            [cell.qcodeBtn setHidden:YES];
        
    }else if (indexPath.section == 1) {
        if (!indexPath.row) {
            cell.leftLabel.text = @"手机号码";
            cell.rightLabel.text = self.user.userInfo.mobile;
        }else {
            cell.leftLabel.text = @"所在地区";
            cell.rightLabel.text = @"未设置";
        }
        [cell showRigthArrow:NO];
    }else if (indexPath.section == 2) {
        cell.topLabel.text = @"个人介绍";
        cell.bottomLabel.text = self.user.userInfo.sign.length ? self.user.userInfo.sign:@"未设置";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 105:10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (!self.isMe) {
            if (!self.isMyFriend) {
                UIView *bgView = [[UIView alloc] init];
                
                UIButton *addFriendBtn = [[UIButton alloc] init];
                [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
                [addFriendBtn setBackgroundColor:kBaseColor];
                [addFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [addFriendBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:addFriendBtn];
                
                addFriendBtn.sd_layout
                .leftSpaceToView(bgView, 15)
                .rightSpaceToView(bgView, 15)
                .topSpaceToView(bgView, 30)
                .heightIs(45);
                addFriendBtn.sd_cornerRadius = @(3);
                return bgView;
            }
        }
    }
    return nil;
}

#pragma mark - 添加好友

- (void)addFriendAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"附加信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入附加信息";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *describeTF = alertController.textFields.firstObject;
//        NSLog(@"addition == %@",describeTF.text);
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = self.userId;
        request.operation = NIMUserOperationRequest;
        request.message = NSStringFormat(@"附加信息：%@",describeTF.text);

        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
            PPLog(@"add friend error == %@", error);
            if (!error) {
                [self toast:@"好友申请已发送"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self toast:@"添加好友失败"];
            }
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
