//
//  MsgAttentionViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MsgAttentionViewController.h"
#import "MsgAttentionCell.h"
#import "MsgAttentionModel.h"
#define kMsgAttentionCellIdentifier @"MsgAttentionCellIdentifier"

@interface MsgAttentionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fansList;
@end

@implementation MsgAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fansList = [NSMutableArray new];
    self.page = 1;
    [self initDataSource];
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [_fansList removeAllObjects];
        [self initDataSource];
        
    }];
    self.tableView.mj_header = self.header;
    
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    self.tableView.mj_footer = self.footer;

    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:NIB_NAMED(@"MsgAttentionCell") forCellReuseIdentifier:kMsgAttentionCellIdentifier];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fansList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:kMsgAttentionCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MsgAttentionModel *model = _fansList[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)initDataSource {
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kMyFans) parameters:@{@"page": @(self.page)} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"data"][@"res"][@"list"];
            for (NSDictionary *dict in arr) {
                MsgAttentionModel *model = [[MsgAttentionModel alloc] initMsgAttentionModelWithDict:dict];
                [_fansList addObject:model];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [self hideLoading];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

- (void)loadMore:(MJRefreshBackNormalFooter *)footer {
    self.page ++;
    [self initDataSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
