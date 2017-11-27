//
//  CollectionDancersViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CollectionDancersViewController.h"
#import "DancerListCell.h"
#import "PersonalCenterViewController.h"
#define kDancerCellIdentifier @"DancerListCellIdentifier"

@interface CollectionDancersViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *danceList;
@end

@implementation CollectionDancersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"舞者";
    self.page = 1;
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [_danceList removeAllObjects];
        [self initDataSource];
    }];
    _tableView.mj_header = self.header;
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    _tableView.mj_footer = self.footer;
    
    _danceList = [NSMutableArray new];
    [self initDataSource];
    
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:NIB_NAMED(@"DancerListCell") forCellReuseIdentifier:kDancerCellIdentifier];
    
}

- (void)initDataSource {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *body = @{@"page": @(self.page)
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kMyLike) parameters:body success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"--%@", responseObject);
        [self.header endRefreshing];
        if ([code isEqualToString:@"0"]) {
            NSArray *dances = responseObject[@"data"][@"res"][@"list"];
            for (NSDictionary *dict in dances) {
                DancerModel *model = [[DancerModel alloc] initDancerModelWithDict:dict];
                [_danceList addObject:model];
                NSLog(@"%@", model.nick_name);
            }
            [_tableView reloadData];
        }
        [hud hide:YES afterDelay:0.2];
    } failure:^(NSError *error) {
        [self.header endRefreshing];
        [hud hide:YES afterDelay:0.2];
    }];
}

- (void)loadMore:(MJRefreshBackNormalFooter *)footer {
    self.page ++;
    [self initDataSource];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _danceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DancerListCell *cell = [tableView dequeueReusableCellWithIdentifier:kDancerCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DancerModel *model = _danceList[indexPath.row];
    [cell.attentionBtn setHidden:YES];
    [cell setModel:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DancerModel *model = _danceList[indexPath.row];
    PersonalCenterViewController *personCenter = [[PersonalCenterViewController alloc] init];
    personCenter.userId = [NSString stringWithFormat:@"%@", model.uid];
    [self.navigationController pushViewController:personCenter animated:YES];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return IMAGE_NAMED(@"nodata");
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
