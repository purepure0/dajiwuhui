//
//  SDChatViewController.m
//  SuperDancer
//
//  Created by yu on 2017/11/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDChatViewController.h"
#import "ChatListHeaderSelectTableViewCell.h"
#import "TeamListForChatTableViewCell.h"

@interface SDChatViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView              *chatListTableView;
@property(strong,nonatomic)UISearchController       *chatVCSearchVC;
@property(strong,nonatomic)NSString                 *searchKeyWords;
@end

@implementation SDChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"舞 队";
    [self setRightImageNamed:@"wd_nav_btn_add" action:@selector(addTeamAction)];
    [self.chatListTableView setTableHeaderView:self.chatVCSearchVC.searchBar];
    [self upDataWithUI];
}

-(void)upDataWithUI{
    [self.view addSubview:self.chatListTableView];
}

- (void)addTeamAction
{
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        ChatListHeaderSelectTableViewCell * chatListHeaderSelectTableViewCell = [[ChatListHeaderSelectTableViewCell alloc]init];
        return chatListHeaderSelectTableViewCell;
    }else{
        TeamListForChatTableViewCell *teamListForChatTableViewCell = [[TeamListForChatTableViewCell alloc]init];
        return teamListForChatTableViewCell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }else{
        return 10;
    }
}

#pragma mark UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (self.chatVCSearchVC.searchBar.text){
        self.searchKeyWords = [self.chatVCSearchVC.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //刷新列表
    }
}



#pragma mark SETTER

-(UITableView *)chatListTableView{
    if(!_chatListTableView){
        _chatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _chatListTableView.delegate = self;
        _chatListTableView.dataSource = self;
        _chatListTableView.separatorStyle = NO;
        [_chatListTableView registerClass:[ChatListHeaderSelectTableViewCell class] forCellReuseIdentifier:@"ChatListHeaderSelectTableViewCell"];
        [_chatListTableView registerClass:[TeamListForChatTableViewCell class] forCellReuseIdentifier:@"TeamListForChatTableViewCell"];
    }
    return _chatListTableView;
}


-(UISearchController *)chatVCSearchVC{
    if (!_chatVCSearchVC) {
        _chatVCSearchVC = [[UISearchController alloc]initWithSearchResultsController:[[UIViewController alloc]init]];
        _chatVCSearchVC.hidesNavigationBarDuringPresentation = NO;
        _chatVCSearchVC.searchResultsUpdater = self;
        _chatVCSearchVC.dimsBackgroundDuringPresentation = YES;
        _chatVCSearchVC.searchBar.placeholder = @"搜索";
        _chatVCSearchVC.searchBar.searchBarStyle = UISearchBarStyleDefault;
    }
    return _chatVCSearchVC;
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
