//
//  SearchTeamViewController.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SearchTeamViewController.h"
#import "TeamListForChatTableViewCell.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "NearTeamViewController.h"

@interface SearchTeamViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>

@property(strong,nonatomic)UISearchController       *classifyVCSearchVC;
@property(copy,nonatomic)NSString                   *classifySearchKeyWords;

@property (weak, nonatomic) IBOutlet UITableView    *classifyListTableView;
@property(strong,nonatomic) NSArray                 *searchClassifyDic;//搜索的类型

@end

@implementation SearchTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //防止searchbar向上偏移64px
    self.title = @"添加舞队";
    self.definesPresentationContext = YES;
    [self upDataWithUI];
    
}

-(void)upDataWithUI{
    
    UIView *searchBarBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    searchBarBackView.backgroundColor = kBackgroundColor;
    [searchBarBackView addSubview:self.classifyVCSearchVC.searchBar];
    [self.view addSubview:searchBarBackView];
    
    self.classifyListTableView.delegate = self;
    self.classifyListTableView.dataSource = self;
    self.classifyListTableView.separatorStyle = NO;
    self.classifyListTableView.backgroundColor = kBackgroundColor;
    [self.classifyListTableView registerClass:[TeamListForChatTableViewCell class] forCellReuseIdentifier:@"TeamListForChatTableViewCell"];
    
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        // 1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        });
                        // 用户第一次同意了访问相机权限
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        
                    } else {
                        // 用户第一次拒绝了访问相机权限
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
            } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
                SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
                
                [DJWYAlertView showOneButtonWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" buttonTitle:@"确定"];
                
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"因为系统原因, 无法访问相册");
            }
        } else {
            [DJWYAlertView showOneButtonWithTitle:@"温馨提示" message:@"未检测到您的摄像头" buttonTitle:@"确定"];
        }

    } else if (indexPath.row == 1) {
        NearTeamViewController *nearTeam = [[NearTeamViewController alloc] init];
        [self.navigationController pushViewController:nearTeam animated:YES];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.classifyVCSearchVC.searchBar.isFirstResponder){
        [self.classifyVCSearchVC.searchBar resignFirstResponder];
    }
}

#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TeamListForChatTableViewCell *teamListForChatTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TeamListForChatTableViewCell"];
    if(!teamListForChatTableViewCell){
        teamListForChatTableViewCell = [[TeamListForChatTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TeamListForChatTableViewCell"];
        
    }
    [teamListForChatTableViewCell updateCellWithArray:self.searchClassifyDic[indexPath.row]];
    return teamListForChatTableViewCell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}




#pragma mark UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (self.classifyVCSearchVC.searchBar.text){
        self.classifySearchKeyWords = [self.classifyVCSearchVC.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //刷新列表
    }
}
#pragma mark searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}


#pragma mark - UISearchControllerDelegate代理
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.classifyListTableView.height =  self.classifyListTableView.height + 54;
}



- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.classifyListTableView.height =  self.classifyListTableView.height - 54;
}



#pragma mark SETTER
-(UISearchController *)classifyVCSearchVC{
    if (!_classifyVCSearchVC) {
        _classifyVCSearchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
        _classifyVCSearchVC.hidesNavigationBarDuringPresentation = YES;
        _classifyVCSearchVC.searchResultsUpdater = self;
        _classifyVCSearchVC.dimsBackgroundDuringPresentation = NO;
        _classifyVCSearchVC.delegate = self;
        
        _classifyVCSearchVC.searchBar.placeholder = @"搜索";
        _classifyVCSearchVC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _classifyVCSearchVC.searchBar.delegate = self;
        
        
    }
    return _classifyVCSearchVC;
}
-(NSArray *)searchClassifyDic{
    if (!_searchClassifyDic) {
        _searchClassifyDic = @[@[@"wd_ico_invite",@"邀请队员",@"您可以邀请队员加入舞队"],@[@"wd_ico_vicinity",@"查看附近的舞队",@""],@[@"wd_ico_sao",@"扫一扫加舞队",@"扫描群二维码名片"]];
    }
    return _searchClassifyDic;
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
