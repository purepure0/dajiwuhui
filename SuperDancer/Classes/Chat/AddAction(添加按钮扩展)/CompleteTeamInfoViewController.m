//
//  CompleteTeamInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/17.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CompleteTeamInfoViewController.h"
#import "DisForTeamEditViewController.h"
#import "CompleteTeamInfoCell.h"
#import <QiniuSDK.h>
#import "AddMembersViewController.h"
#import "TZImagePickerController.h"
#import "EditTeamAddressViewController.h"
@interface CompleteTeamInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong)NSMutableArray *members; //成员
@property (nonatomic, strong)NSString *teamIntro; //舞队介绍
@property (nonatomic, strong)NSArray *area;
@property (nonatomic, assign)BOOL allowMemberInvite; //允许成员邀请队员


@end

@implementation CompleteTeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善资料";
    _members = [NSMutableArray arrayWithObject:[SDUser sharedUser].userId];
    _allowMemberInvite = NO;
    _teamIntro = @"未填写";
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
    _members = [NSMutableArray arrayWithObject:[SDUser sharedUser].userId];
    
}


- (NSArray *)data {
    if (_data == nil) {
        _data = @[
  @[@{}],
  @[@{},@{}],
  @[@{@"title": @"领队名称", @"content": [SDUser sharedUser].nickName},
    @{@"title": @"成立时间", @"content": [self createTime]},
    @{@"title": @"所在地区", @"content": @"未设置"},
    @{@"title": @"允许成员邀请队员", @"content": @""}],
  @[@{@"title": @"舞队介绍", @"content": @""}]];
    }
    return _data;
}

- (void)finishAction
{
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,KQiniuToken) parameters:nil success:^(id responseObject) {
        
        NSString *token = responseObject[@"data"][@"res"][@"token"];
        PPLog(@"七牛token = %@",token);
        NSData *imageData = UIImageJPEGRepresentation(_avatarImage, 0.5f);
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        [upManager putData:imageData key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      PPLog(@"Qiniu info = %@", info);
                      PPLog(@"Qiniu resp = %@", resp);
                      PPLog(@"Qiniu key = %@", key);
                      
                      if (info.ok) {
                          [self hideLoading];
                          PPLog(@"成功");
                          NSString *avatarURL = NSStringFormat(@"%@%@", kQiniuURLHost, resp[@"key"]);
                          NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                          option.name = self.teamName;
                          option.type = NIMTeamTypeAdvanced;
                          option.avatarUrl = avatarURL;
                          option.joinMode = NIMTeamJoinModeNeedAuth;
                          option.inviteMode = _allowMemberInvite;
                          option.beInviteMode = NIMTeamBeInviteModeNeedAuth;
                          option.intro = _teamIntro;
                          
                          [[[NIMSDK sharedSDK] teamManager] createTeam:option users:_members completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
                              if (error == nil) {
                                  NSLog(@"%@--%@", teamId, failedUserIds);
                                  [self.navigationController popToRootViewControllerAnimated:YES];
                              }else {
                                  NSLog(@"error:%@", error);
                                  [self toast:@"创建失败"];
                              }
                          }];
                      }else {
                          [self hideLoading];
                          PPLog(@"失败");
                      }
                  } option:nil];
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 176;
    } else if (indexPath.section == 1 || indexPath.section == 2) {

        if (indexPath.section == 1 && indexPath.row == 1) {
            return 70;
        }
        
        return 50;
    } else {
        return 90;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompleteTeamInfoCell *cell = [[CompleteTeamInfoCell alloc] initWithTableView:tableView andIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.avatarImageView.image = _avatarImage;
        cell.teamName.text = _teamName;
        [cell.changeAvatarBtn addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"舞队成员";
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld人", _members.count];
        } else {
            cell.dataSource = _members;
        }
    }else if (indexPath.section == 2) {
        
        if (indexPath.row <= 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            UISwitch *s = [[UISwitch alloc] init];
            s.on = _allowMemberInvite;
            s.onTintColor = kBaseColor;
            [s addTarget:self action:@selector(swChangedvalue:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
        
        cell.textLabel.text = self.data[indexPath.section][indexPath.row][@"title"];
        cell.detailLabel.text = self.data[indexPath.section][indexPath.row][@"content"];
    }else {
        cell.introduceLabel.text = _teamIntro;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        AddMembersViewController *addMembers = [[AddMembersViewController alloc] init];
        addMembers.members = _members;
        addMembers.finished = ^{
            NSLog(@"%@", weakSelf.members);
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:addMembers animated:YES];
    }else if (indexPath.section == 3) {
        if (indexPath.row == 2) {
            EditTeamAddressViewController *editTeamAddress = [[EditTeamAddressViewController alloc] init];
            [self.navigationController pushViewController:editTeamAddress animated:YES];
        }
    }else if (indexPath.section == 3) {
        DisForTeamEditViewController *DDTVC = [[DisForTeamEditViewController alloc]init];
        if (![_teamIntro isEqualToString:@"未填写"]) {
            DDTVC.teamIntro = _teamIntro;
        }
        
        DDTVC.editFinised = ^(NSString *teamIntro) {
            _teamIntro = teamIntro;
            [weakSelf.tableView reloadData];
        };
        
        [self.navigationController pushViewController:DDTVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)createTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSDate *date = [NSDate date];
    return [dateFormatter stringFromDate:date];
}

- (void)swChangedvalue:(UISwitch *)sw {
    _allowMemberInvite = sw.isOn;
}

- (void)changeAvatar {
    NSLog(@"更换头像");
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]init];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _avatarImage = photos[0];
        [weakSelf.tableView reloadData];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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
