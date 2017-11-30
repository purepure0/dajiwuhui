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


@interface SDChatViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(strong,nonatomic)UITableView              *chatListTableView;
@property(strong,nonatomic)UISearchController       *chatVCSearchVC;
@property(strong,nonatomic)NSString                 *searchKeyWords;
@end

@implementation SDChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"舞 队";
    //防止searchbar向上偏移64px
    self.definesPresentationContext = YES;
    [self setRightImageNamed:@"wd_nav_btn_add" action:@selector(addTeamAction)];
    
    [self upDataWithUI];
}

-(void)upDataWithUI{
    
    UIView *searchBarBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    searchBarBackView.backgroundColor = kBackgroundColor;
    [searchBarBackView addSubview:self.chatVCSearchVC.searchBar];
    [self.view addSubview:searchBarBackView];
    [self.view addSubview:self.chatListTableView];
    
}

- (void)addTeamAction
{
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 44;
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        ChatListHeaderSelectTableViewCell * chatListHeaderSelectTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ChatListHeaderSelectTableViewCell"];
        if(!chatListHeaderSelectTableViewCell){
            chatListHeaderSelectTableViewCell = [[ChatListHeaderSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatListHeaderSelectTableViewCell"];
        }
        if(indexPath.row == 0){
            [chatListHeaderSelectTableViewCell updateCellWithData:@{@"states":@"0",@"numOfNews":@"5"}];
        }else{
            [chatListHeaderSelectTableViewCell updateCellWithData:@{@"states":@"1"}];
        }
        
        
        return chatListHeaderSelectTableViewCell;
    }else{
        TeamListForChatTableViewCell *teamListForChatTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"TeamListForChatTableViewCell"];
        if(!teamListForChatTableViewCell){
            teamListForChatTableViewCell = [[TeamListForChatTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TeamListForChatTableViewCell"];
            
        }
        [teamListForChatTableViewCell updateCellWithData:nil];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    sectionHeaderView.backgroundColor = kBackgroundColor;
    return sectionHeaderView;
}


#pragma mark UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (self.chatVCSearchVC.searchBar.text){
        self.searchKeyWords = [self.chatVCSearchVC.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //刷新列表
    }
}
#pragma mark searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}



#pragma mark SETTER

-(UITableView *)chatListTableView{
    if(!_chatListTableView){
        
        if(Device_Is_iPhoneX){
            _chatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, kScreenWidth, kScreenHeight-kNAVHeight-54-83)];
        }else{
            _chatListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, kScreenWidth, kScreenHeight-kNAVHeight-54-49)];
        }
        NSLog(@"%f",kNAVHeight);
        _chatListTableView.delegate = self;
        _chatListTableView.dataSource = self;
        _chatListTableView.separatorStyle = NO;
        _chatListTableView.backgroundColor = [UIColor redColor];
        [_chatListTableView registerClass:[ChatListHeaderSelectTableViewCell class] forCellReuseIdentifier:@"ChatListHeaderSelectTableViewCell"];
        [_chatListTableView registerClass:[TeamListForChatTableViewCell class] forCellReuseIdentifier:@"TeamListForChatTableViewCell"];
    }
    return _chatListTableView;
}


-(UISearchController *)chatVCSearchVC{
    if (!_chatVCSearchVC) {
        _chatVCSearchVC = [[UISearchController alloc]initWithSearchResultsController:[[UIViewController alloc]init]];
        _chatVCSearchVC.hidesNavigationBarDuringPresentation = YES;
        _chatVCSearchVC.searchResultsUpdater = self;
        _chatVCSearchVC.dimsBackgroundDuringPresentation = NO;
        
        _chatVCSearchVC.searchBar.placeholder = @"搜索";
        _chatVCSearchVC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
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
