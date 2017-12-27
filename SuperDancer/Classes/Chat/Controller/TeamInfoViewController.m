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
#import "GroupVideoViewController.h"
#import "MemberManageViewController.h"
#import "AddMembersViewController.h"
#import "TeamManageViewController.h"
#import "TeamQRCodeViewController.h"
#import "TeamSessionRemoteHistoryViewController.h"
#import "TZImagePickerController.h"
#import <QiniuSDK.h>
#import "ModifyTeamNicknameViewController.h"

@interface TeamInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
// 城市
@property (nonatomic, copy) NSString *locality;
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 头像
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIImage *iconImg;

@property (nonatomic, strong)NSMutableArray *teamMemberUserIDs;
@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    _isTeamOwner = [_team.owner isEqualToString:[SDUser sharedUser].userId];
    //UserId = 81692

    _teamMemberUserIDs = [NSMutableArray new];
    
    // 初始化群资料
    [self initTeamData];
    // 获取群成员
    [self fetchTeamMembers];
    // 获取群信息
    [self fetchTeamInfo];
}

- (void)fetchTeamMembers {
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.team.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        if (!error) {
            [_teamMemberUserIDs removeAllObjects];
            for (NIMTeamMember *member in members) {
                [_teamMemberUserIDs addObject:member.userId];
                // 获取本人群资料
                if ([member.userId isEqualToString:self.users.userId]) {
//                    PPLog(@"fetch myself user nickname == %@",member.nickname);
                    if (member.nickname || member.nickname.length ) {
                        self.nickname = member.nickname;
                        [self initTeamData];
                    }
                }
            }
        }
    }];
}

- (void)fetchTeamInfo {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:self.team.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        self.team = team;
        PPLog(@"Team == %@",team);
        if (!error) {
            if (team.clientCustomInfo.length || team.clientCustomInfo) {
                NSArray *data = [NSJSONSerialization JSONObjectWithData:[team.clientCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
                NSDictionary *teamInfo = [NSMutableArray arrayWithArray:data].lastObject;
                NSArray *localityArray = [teamInfo[@"locality"] componentsSeparatedByString:@","];
                if (localityArray.count == 3) {
                    self.locality = [localityArray objectAtIndex:1];
                    [self initTeamData];
                }
            }
        }
    }];
}

- (void)initTeamData
{
    if (_isTeamOwner) {
        if (!self.locality || !self.locality.length) {
            self.locality = @"未设置";
        }
        if (!self.nickname || !self.nickname.length) {
            self.nickname = @"未设置";
        }
        _data = @[@[@{@"icon": self.team.avatarUrl, @"nickname": self.team.teamName, @"city": self.locality,@"isTeamOwner":@(1)}],
                  @[@{@"#": @"#"}],
                  @[@{@"title": @"我的舞队名片", @"content": self.nickname},
                    @{@"#": @"#"}],
                  @[@{@"title": @"舞队管理", @"content": @""}],
                  @[@{@"title": @"聊天记录", @"content": @""}]
                  ];
    } else {
        _data = @[
                  @[@{@"icon": self.team.avatarUrl, @"nickname": self.team.teamName, @"city": @"菏泽市",@"isTeamOwner":@(0)}],
                  @[@{@"#": @"#"}],
                  @[@{@"title": @"我的舞队名片", @"content": @"未设置"},
                    @{@"#": @"#"}],
                  @[@{@"title": @"聊天记录", @"content":@""}],
                  @[@{@"title": @"领队名称", @"content": @"舞者名称007"},
                    @{@"title": @"成立时间", @"content": @"2017-10-10"},
                    @{@"title": @"所在地区", @"content": @"山东省菏泽市牡丹区"}],
                  @[@{@"title": @"舞队介绍", @"content": @"舞队坐落于山东省菏泽市牡丹区，舞队成员有10名"}]
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
        if (indexPath.section == 0) {
            [cell updateFirstCellWithData:dic];
            self.iconImgView = cell.iconImageView;
        }else if (indexPath.section == 1) {
            [cell updateFourthCellWithData:dic];
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [cell updateSecondCellWithData:dic];
                if (indexPath.row == 0) {
                    [cell showRigthArrow:YES];
                }
            }else {
                [cell updateFifthCellWithData:dic];
                __weak typeof(self) weakSelf = self;
                cell.addMemberBlock = ^{
                    AddMembersViewController *addMember = [[AddMembersViewController alloc] init];
                    addMember.team = _team;
                    addMember.teamMemberUserIDs = _teamMemberUserIDs;
                    [weakSelf.navigationController pushViewController:addMember animated:YES];
                };
            }
        }else if (indexPath.section == 3) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }else {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }
    }else {
        if (indexPath.section == 0) {
            [cell updateFirstCellWithData:dic];
        }else if (indexPath.section == 1) {
            [cell updateFourthCellWithData:dic];
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [cell updateSecondCellWithData:dic];
                if (indexPath.row == 0) {
                    [cell showRigthArrow:YES];
                }
            }else {
                [cell updateFifthCellWithData:dic];
            }
        }else if (indexPath.section == 3) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
            
        }else if (indexPath.section == 4) {
            [cell updateSecondCellWithData:dic];
            if (indexPath.row == 0) {
                [cell showRigthArrow:YES];
            }
        }else {
            [cell updateThirdCellWithData:dic];
            
        }
    }
#pragma mark - 公告/视频/投票/签到
    // 公告/视频/投票/签到
    @weakify(self);
    [cell setHandleBtnBlock:^(NSInteger index) {
        @strongify(self);
        switch (index) {
            case 10:
            {//群公告
                GroupNoticeViewController *gn = [[GroupNoticeViewController alloc] init];
                [self.navigationController pushViewController:gn animated:YES];
            }
                break;
            case 11:
            {//群视频
                GroupVideoViewController *gv = [[GroupVideoViewController alloc] init];
                [self.navigationController pushViewController:gv animated:YES];
            }
                break;
            case 12:
                break;
            case 13:
                break;
            default:
                break;
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
        if (indexPath.section == 2) {
            if (!indexPath.row) {//群昵称
                ModifyTeamNicknameViewController *tn = [[ModifyTeamNicknameViewController alloc] init];
                tn.team = self.team;
                tn.nickname = self.nickname;
                [self.navigationController pushViewController:tn animated:YES];
            }else {
                
            }
        }else if (indexPath.section == 3) {//舞队管理
            TeamManageViewController *tm = [[TeamManageViewController alloc] init];
            tm.team = self.team; //123 id = 239423354
//            PPLog(@"team id = %@",self.team.teamId);
            [self.navigationController pushViewController:tm animated:YES];
        }else if (indexPath.section == 4){//聊天记录
            NIMSession *session = [NIMSession session:self.team.teamId type:NIMSessionTypeTeam];
            TeamSessionRemoteHistoryViewController *rh = [[TeamSessionRemoteHistoryViewController alloc] initWithSession:session];
            [self.navigationController pushViewController:rh animated:YES];
        }
    }else {
        if (indexPath.section == 2) {
            if (!indexPath.row) {//群昵称
                NSLog(@"舞队名片");
            }else {
                MemberManageViewController *memberMag = [[MemberManageViewController alloc] init];
                [self.navigationController pushViewController:memberMag animated:YES];
            }
        }else if (indexPath.section == 3) {
            NSLog(@"聊天记录");
            TeamSessionRemoteHistoryViewController *rh = [[TeamSessionRemoteHistoryViewController alloc] init];
//            rh.sessionConfig = [[TeamSessionViewController alloc] init];
            [self.navigationController pushViewController:rh animated:YES];
        }else  if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                NSLog(@"领队名称");
            }
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
            NSData *imageData = UIImageJPEGRepresentation(photos[0], 0.5f);
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
