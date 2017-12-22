//
//  MemberManageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MemberManageViewController.h"
#import "MemberManageCell.h"


@interface MemberManageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>
{
    MemberManageCell *_memberManageCell;
    BOOL _isEdit;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
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
    
    self.memberList = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    self.searchResultList = [NSMutableArray array];
    
    [self setupSearchBar];
    [self setupTableView];
    
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

- (void)setupSearchBar
{
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.view addSubview:_searchController.searchBar];
    
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.placeholder = @"搜索";
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
        
    _tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(_searchController.searchBar, 0)
    .bottomEqualToView(self.view);
    
    [self.tableView registerNib:NIB_NAMED(@"MemberManageCell") forCellReuseIdentifier:kMemberManageCellIdentifier];
}

#pragma mark - UISearchResultUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    PPLog(@"updateSearchResultsForSearchController");
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberManageCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemberManageCellIdentifier];
    [cell layoutSubviews:_isEdit indexPath:indexPath];
    
    @weakify(self);
    cell.deleteBlock = ^(NSInteger _index) {
        @strongify(self);
        [self deleteMember:_index];
    };
    return cell;
}

- (void)deleteMember:(NSInteger)_index
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"踢出队员" message:@"该操作不可撤销，是否确认踢出该队员" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        PPLog(@"踢出%ld",_index);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:confirmAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
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
