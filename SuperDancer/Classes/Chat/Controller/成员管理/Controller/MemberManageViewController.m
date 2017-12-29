//
//  MemberManageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MemberManageViewController.h"
#import "MemberManageCell.h"


@interface MemberManageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MemberManageCell *_memberManageCell;
    BOOL _isEdit;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *memberList;
@property (nonatomic, strong) NSMutableArray *searchResultList;

@end

static NSString *kMemberManageCellIdentifier = @"kMemberManageCellIdentifier";

@implementation MemberManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"成员管理";
    self.definesPresentationContext = YES;
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightItemTitle:@"管理" action:@selector(manageAction)];
    [self.tableView registerNib:NIB_NAMED(@"MemberManageCell") forCellReuseIdentifier:kMemberManageCellIdentifier];
    self.memberList = [NSMutableArray new];
    self.searchResultList = [NSMutableArray new];
    [self initDataSource];
    
}

- (void)initDataSource {
    [self showLoading];
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:_team.teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        NSLog(@"%@", members);
        if (error) {
            [self hideLoading];
            [self toast:error.localizedDescription];
        }else {
            NSArray *teamMembers = (NSMutableArray *)members;
            NSMutableArray *teamMembersUserID = [NSMutableArray new];
            for (NIMTeamMember *member in teamMembers) {
                [teamMembersUserID addObject:member.userId];
            }
            NSLog(@"%@", teamMembersUserID);
            if (teamMembersUserID.count != 0) {
                [[NIMSDK sharedSDK].userManager fetchUserInfos:(NSArray *)teamMembersUserID completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                    NSLog(@"aaaaaaaaaaaaaaaaaaaaa");
                    if (error) {
                        [self hideLoading];
                        [self toast:error.localizedDescription];
                    }else {
                        self.memberList = (NSMutableArray *)users;
                        self.searchResultList = (NSMutableArray *)users;
                        [self hideLoading];
                        [self.tableView reloadData];
                    }
                }];
            }else {
                [self hideLoading];
                [self toast:@"请求失败，请重新请求"];
            }
        }
    }];
}


- (void)manageAction
{
    NSString *string = [self.rightBtn titleForState:UIControlStateNormal];
    if ([string isEqualToString:@"管理"]) {
        _isEdit = YES;
        [self setRightItemTitle:@"完成" action:@selector(manageAction)];
    } else if ([string isEqualToString:@"完成"]) {
        _isEdit = NO;
        [self setRightItemTitle:@"管理" action:@selector(manageAction)];
    }
    [self.tableView reloadData];
}



#pragma mark - UISearchResultUpdating
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *keyword = searchBar.text;
    if (keyword.length == 0) {
        _searchResultList = [_memberList mutableCopy];
        [self.tableView reloadData];
    }else {
        NSMutableArray *tem = [NSMutableArray new];
        for (NIMUser *user in _memberList) {
            if ([user.userInfo.nickName rangeOfString:keyword].location != NSNotFound) {
                [tem addObject:user];
            }
        }
        _searchResultList = tem;
        [self.tableView reloadData];
    }
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberManageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemberManageCellIdentifier];
    [cell layoutSubviews:_isEdit indexPath:indexPath];
    NIMUser *member = _searchResultList[indexPath.row];
    NSLog(@"%@", member.userInfo.nickName);
    [cell.iconImg setImageWithURL:[NSURL URLWithString:member.userInfo.avatarUrl] placeholder:[UIImage imageNamed:@"myaccount"]];
    cell.nameLabel.text = member.userInfo.nickName;
    cell.introduceLabel.text = member.userInfo.sign;
    @weakify(self);
    cell.deleteBlock = ^(NSInteger _index) {
        @strongify(self);
        [self deleteMember:_index];
    };
    return cell;
}

- (void)deleteMember:(NSInteger)index
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"踢出队员" message:@"该操作不可撤销，是否确认踢出该队员" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        PPLog(@"踢出%ld",index);
        [self hideLoading];
        NIMUser *user = _searchResultList[index];
        [[NIMSDK sharedSDK].teamManager kickUsers:@[user.userId] fromTeam:_team.teamId completion:^(NSError * _Nullable error) {
            [self hideLoading];
            if (error) {
                [self toast:error.localizedDescription];
            }else {
                [self toast:@"删除成功"];
                [_searchResultList removeObject:user];
                for (NIMUser *item in _memberList) {
                    if (user.userId == item.userId) {
                        [_memberList removeObject:item];
                    }
                }
                [_tableView deleteRow:index inSection:0 withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:confirmAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
