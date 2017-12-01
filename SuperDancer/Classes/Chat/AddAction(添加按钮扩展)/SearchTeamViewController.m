//
//  SearchTeamViewController.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SearchTeamViewController.h"
#import "TeamListForChatTableViewCell.h"

@interface SearchTeamViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>

@property(strong,nonatomic)UISearchController       *classifyVCSearchVC;
@property(strong,nonatomic)NSString                 *classifySearchKeyWords;

@property (weak, nonatomic) IBOutlet UITableView    *classifyListTableView;

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
    [teamListForChatTableViewCell updateCellWithData:nil];
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
