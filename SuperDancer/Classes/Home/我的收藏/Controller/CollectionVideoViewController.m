//
//  CollectionVideoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CollectionVideoViewController.h"
#import "CollectionModel.h"
#import "CollectionCell.h"
#import "MovePlayerViewController.h"
#define kCollectionCellIdentifier @"CollectionCellIdentifier"

@interface CollectionVideoViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *videoList;
@end

@implementation CollectionVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    _tableView.tableFooterView = [UIView new];
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [_videoList removeAllObjects];
        [self initDataSource];
    }];
    _tableView.mj_header = self.header;
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    
    _tableView.mj_footer = self.footer;
    
    [_tableView registerNib:NIB_NAMED(@"CollectionCell") forCellReuseIdentifier:kCollectionCellIdentifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectionCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CollectionModel *model = _videoList[indexPath.row];
    cell.model = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAutoWidth(85);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionModel *model = _videoList[indexPath.row];
    [_videoList removeObject:model];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionModel *model = _videoList[indexPath.row];
    MovePlayerViewController *player = [[MovePlayerViewController alloc] init];
    player.vid = model.vid;
    player.videoURL = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:player animated:YES];
}

- (void)initDataSource {
    [self showLoading];
    _videoList = [NSMutableArray new];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kMyCollection) parameters:nil success:^(id responseObject) {
        PPLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *list = responseObject[@"data"][@"collect"];
            for (NSDictionary *dict in list) {
                CollectionModel *model = [[CollectionModel alloc] initCollectionModelWithDict:dict];
                [_videoList addObject:model];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
        
        [self hideLoading];
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        [self hideLoading];
    }];
}

- (void)loadMore:(MJRefreshBackNormalFooter *)footer {
    self.page ++;
    [self initDataSource];
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
