//
//  TeamInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "TeamJoinCell.h"
#import "GroupNoticeViewController.h"
#import "MemberManageViewController.h"
#import "AddMembersViewController.h"
#import "TeamManageViewController.h"
#import "TeamQRCodeViewController.h"
#import "TeamSessionRemoteHistoryViewController.h"
#import "TZImagePickerController.h"
#import <QiniuSDK.h>
#import "ModifyTeamNicknameViewController.h"
#import "Utility.h"
#import "GroupNoticeViewController.h"

@interface TeamInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
// 城市
@property (nonatomic, copy) NSString *city;
// 位置
@property (nonatomic, copy) NSString *locality;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 头像
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIImage *iconImg;

@property (nonatomic, strong)NSArray<NIMUser *> *members;
@property (nonatomic, strong)NSMutableArray *teamMemberUserIDs;

@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    if (_team != nil) {
        _teamID = _team.teamId;
    }
    _isTeamOwner = [_team.owner isEqualToString:[SDUser sharedUser].userId];
    //UserId = 81692

    _teamMemberUserIDs = [NSMutableArray new];

    // 初始化群资料
    [self initTeamData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取群成员
    [self fetchTeamMembers];
    // 获取群信息
    [self fetchTeamInfo];
}
- (void)fetchTeamMembers {
    NSLog(@"%@", _teamID);
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:_teamID completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        if (!error) {
            [_teamMemberUserIDs removeAllObjects];
            for (NIMTeamMember *member in members) {
                if ([member.userId isEqualToString:_team.owner]) {
                    [_teamMemberUserIDs insertObject:member.userId atIndex:0];
                } else {
                    [_teamMemberUserIDs addObject:member.userId];
                }
                // 获取本人群资料
                if ([member.userId isEqualToString:self.users.userId]) {
                    if (member.nickname || member.nickname.length ) {
                        self.nickname = member.nickname;
                        [self fetchTeamInfo];
                        [self initTeamData];
                    }
                }
            }
            //获取成员信息
            if (_teamMemberUserIDs.count != 0) {
                self.members = [NSArray array];
                [[NIMSDK sharedSDK].userManager fetchUserInfos:_teamMemberUserIDs completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                    self.members = users;
                    [self.tableView reloadData];
                }];
            }
        }
    }];
}

- (void)fetchTeamInfo {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:_teamID completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        PPLog(@"Team == %@",team);
        if (!error) {
            self.team = team;
            if (team.clientCustomInfo.length) {
                NSArray *data = [NSJSONSerialization JSONObjectWithData:[team.clientCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
                NSDictionary *teamInfo = [NSMutableArray arrayWithArray:data].lastObject;
                NSArray *localityArray = [teamInfo[@"locality"] componentsSeparatedByString:@","];
                if (localityArray.count == 3) {
                    self.city = localityArray[1];
                    self.locality = NSStringFormat(@"%@%@%@",localityArray[0],localityArray[1],localityArray[2]);
                    [self initTeamData];
                }
            }
        }else {
            [self toast:error.localizedDescription];
        }
    }];
}

- (void)initTeamData
{
    if (!self.city.length) {
        self.city = @"未设置";
    }
    if (!self.nickname.length) {
        self.nickname = @"未设置";
    }
    
    if (!self.team.intro.length) {
        self.team.intro = @"未设置";
    }
    
    if (!self.locality.length) {
        self.locality = @"未设置";
    }
    
    if (_isTeamOwner) {
        _data = @[@[@{@"icon": self.team.avatarUrl, @"nickname": self.team.teamName, @"city": self.city,@"isTeamOwner":@(1)}],
                  @[@{@"title": @"我的舞队名片", @"content": self.nickname},
                    @{@"#": @"#"}],
                  @[@{@"title": @"舞队公告", @"content": @""}],
                  @[@{@"title": @"舞队管理", @"content": @""}],
                  @[@{@"title": @"聊天记录", @"content": @""}]
                  ];
    } else {
        _data = @[
                  @[@{@"icon": self.team.avatarUrl, @"nickname": self.team.teamName, @"city": @"菏泽市",@"isTeamOwner":@(0)}],
                  @[@{@"title": @"我的舞队名片", @"content": self.nickname},
                    @{@"#": @"#"}],
                  @[@{@"title": @"舞队公告", @"content": @""}],
                  @[@{@"title": @"聊天记录", @"content": @""}],
                  @[@{@"title": @"领队名称", @"content": @"舞者名称007"},
                    @{@"title": @"成立时间", @"content":[Utility NSDateToString:NSStringFormat(@"%f",self.team.createTime)]},
                    @{@"title": @"所在地区", @"content": self.locality}],
                  @[@{@"title": @"舞队介绍", @"content":self.team.intro}]
                  ];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamJoinCell *cell = [TeamJoinCell initTableViewCellWith:tableView indexPath:indexPath joined:YES];
    
    NSDictionary *dic = _data[indexPath.section][indexPath.row];
    
    if (_isTeamOwner) {
        if (!indexPath.section) {
            [cell updateFirstCellWithData:dic];
            self.iconImgView = cell.iconImageView;
        }else if (indexPath.section == 1) {
            if (!indexPath.row ) {
                [cell updateSecondCellWithData:dic];
                [cell showRigthArrow:YES];
            } else {
                [cell updateFifthCellWithData:self.members];
            }
        }else if (indexPath.section == 2) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }else if (indexPath.section == 3) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }else {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }
    }else {
        if (!indexPath.section) {
            [cell updateFirstCellWithData:dic];
        }else if (indexPath.section == 1) {
            if (!indexPath.row) {
                [cell updateSecondCellWithData:dic];
                [cell showRigthArrow:YES];
            } else {
                [cell updateFifthCellWithData:self.members];
            }
        }else if (indexPath.section == 2) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }else if (indexPath.section == 3) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
            
        }else if (indexPath.section == 4) {
            [cell updateSecondCellWithData:dic];
            if (indexPath.row == 0) {
                [cell showRigthArrow:NO];
            }
        }else {
            [cell updateThirdCellWithData:dic];
        }
    }
#pragma mark - 邀请好友
    @weakify(self);
    [cell setAddMemberBlock:^{
        @strongify(self);
        if (_isTeamOwner) {
            AddMembersViewController *am = [[AddMembersViewController alloc] init];
            am.team = _team;
            am.teamMemberUserIDs = _teamMemberUserIDs;
            [self.navigationController pushViewController:am animated:YES];
        } else {
            if (_team.inviteMode == NIMTeamInviteModeAll) {
                AddMembersViewController *am = [[AddMembersViewController alloc] init];
                am.team = _team;
                am.teamMemberUserIDs = _teamMemberUserIDs;
                [self.navigationController pushViewController:am animated:YES];
            }else {
                [self toast:@"只有群主可以邀请好友"];
            }
        }
    }];
#pragma mark - 舞队二维码
    [cell setQRCodeBlock:^{
        @strongify(self);
        TeamQRCodeViewController *qRCode = [[TeamQRCodeViewController alloc] init];
        qRCode.team = self.team;
        [self.navigationController pushViewController:qRCode animated:YES];
    }];
    
#pragma mark - 更换头像
    [cell setIconImgBlock:^{
        @strongify(self);
        [self uploadIconImg];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == _data.count - 1) {
        return 75;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isTeamOwner) {
        if (indexPath.section == 1) {
            if (!indexPath.row) {//群昵称
                ModifyTeamNicknameViewController *tn = [[ModifyTeamNicknameViewController alloc] init];
                tn.team = self.team;
                tn.nickname = self.nickname;
                [self.navigationController pushViewController:tn animated:YES];
            }else {
                MemberManageViewController *memberMag = [[MemberManageViewController alloc] init];
                memberMag.team = _team;
                memberMag.isOwner = _isTeamOwner;
                [self.navigationController pushViewController:memberMag animated:YES];
            }
        } else if (indexPath.section == 2) {//舞队公告
            GroupNoticeViewController *gn = [[GroupNoticeViewController alloc] init];
            gn.canPublishAnnouncement = YES;
            gn.team = self.team;
            [self.navigationController pushViewController:gn animated:YES];
        } else if (indexPath.section == 3) {//舞队管理
            TeamManageViewController *tm = [[TeamManageViewController alloc] init];
            tm.team = self.team;
            [self.navigationController pushViewController:tm animated:YES];
        }else if (indexPath.section == 4){//聊天记录
            NIMSession *session = [NIMSession session:self.team.teamId type:NIMSessionTypeTeam];
            TeamSessionRemoteHistoryViewController *rh = [[TeamSessionRemoteHistoryViewController alloc] initWithSession:session];
            [self.navigationController pushViewController:rh animated:YES];
        }
    }else {
        if (indexPath.section == 1) {
            if (!indexPath.row) {//群昵称
                ModifyTeamNicknameViewController *tn = [[ModifyTeamNicknameViewController alloc] init];
                tn.team = self.team;
                tn.nickname = self.nickname;
                [self.navigationController pushViewController:tn animated:YES];
            }else {
                MemberManageViewController *memberMag = [[MemberManageViewController alloc] init];
                memberMag.team = _team;
                memberMag.isOwner = _isTeamOwner;
                [self.navigationController pushViewController:memberMag animated:YES];
            }
        } else if (indexPath.section == 2) {//群公告
            GroupNoticeViewController *gn = [[GroupNoticeViewController alloc] init];
            gn.canPublishAnnouncement = NO;
            gn.team = self.team;
            [self.navigationController pushViewController:gn animated:YES];
        } else if (indexPath.section == 3) {//聊天记录
            NIMSession *session = [NIMSession session:self.team.teamId type:NIMSessionTypeTeam];
            TeamSessionRemoteHistoryViewController *rh = [[TeamSessionRemoteHistoryViewController alloc] initWithSession:session];
            [self.navigationController pushViewController:rh animated:YES];
        }
    }
}

- (void)sendMessage:(UIButton *)btn {
    NSLog(@"发送消息");
}

#pragma mark - 修改群头像
- (void)uploadIconImg {
    TZImagePickerController *picker = [[TZImagePickerController alloc]init];
    picker.maxImagesCount = 1;
    picker.showSelectBtn = NO;
    picker.allowCrop = YES;
    picker.needCircleCrop = YES;
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.iconImg = [photos objectAtIndex:0];
        [self showLoading];
        [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,KQiniuToken) parameters:nil success:^(id responseObject) {
            NSString *token = responseObject[@"data"][@"res"][@"token"];
//            PPLog(@"七牛token = %@",token);
            NSData *imageData = UIImageJPEGRepresentation(photos[0], 0.1f);
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            
            [upManager putData:imageData key:nil token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                PPLog(@"Qiniu info === %@**resp === %@**key === %@",info,resp,key);
                          
                if (info.ok) {
                    PPLog(@"上传qiniu成功");
                    NSString *avatarURL = NSStringFormat(@"%@%@", kQiniuURLHost, resp[@"key"]);
                    PPLog(@"upload avatar url == %@",avatarURL);
                    [[NIMSDK sharedSDK].teamManager updateTeamAvatar:avatarURL teamId:self.team.teamId completion:^(NSError * _Nullable error) {
                        if (!error) {
                            [self hideLoading];
                            self.iconImgView.image = self.iconImg;
                        } else {
                            PPLog(@"upload image error == %@",error.description);
                            [self toast:@"上传图片失败"];
                        }
                    }];
                    }else {
                        [self hideLoading];
                        [self toast:@"上传图片失败"];
                    }
            } option:nil];
        } failure:^(NSError *error) {
            [self hideLoading];
        }];
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
