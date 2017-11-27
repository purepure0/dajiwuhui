//
//  BrowsingHistoryViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/14.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BrowsingHistoryViewController.h"
#import "HistoryCell.h"
#import "HistoryModel.h"
#import "VideoListModel.h"
#import "MovePlayerViewController.h"
#define kHistoryCellIdentifier @"HistoryCellIdentifier"

@interface BrowsingHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sectionArr;
@property (nonatomic, strong)NSMutableArray *dateMarkList;

@end

@implementation BrowsingHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:NIB_NAMED(@"HistoryCell") forCellReuseIdentifier:kHistoryCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sectionArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HistoryModel *model = _sectionArr[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAutoWidth(85);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kAutoWidth(25);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kAutoWidth(25))];
    view.backgroundColor = kColorRGB(249, 249, 249);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, kAutoWidth(4), 200, kAutoWidth(17))];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = kColorRGB(189, 189, 189);
    label.text = _dateMarkList[section];
    [view addSubview:label];
    return view;
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
    HistoryModel *model = _sectionArr[indexPath.section][indexPath.row];
    [_sectionArr[indexPath.section] removeObject:model];
    for (int i = 0; i < _sectionArr.count; i++) {
        NSArray *arr = _sectionArr[i];
        if (arr.count == 0) {
            [_sectionArr removeObject:arr];
            [_dateMarkList removeObjectAtIndex:i];
        }
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryModel *model = _sectionArr[indexPath.section][indexPath.row];
    MovePlayerViewController *player = [[MovePlayerViewController alloc] init];
    player.vid = model.vid;
    player.videoURL = [NSURL URLWithString:model.url];
    [self.navigationController pushViewController:player animated:YES];
}

#pragma mark -- 数据请求
- (void)initDataSource {
    
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kBrowseVideoLog) parameters:nil success:^(id responseObject) {
        PPLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *list = responseObject[@"data"][@"play_log"];
            NSMutableArray *arr = [NSMutableArray new];
            NSString *tmp = [NSString stringWithFormat:@"%@", list];
            if (tmp.length == 0) {
                return;
            }
            for (NSDictionary *dict in list) {
                HistoryModel *model = [[HistoryModel alloc] initBrowseVideoModelWithDict:dict];
                [arr addObject:model];
            }
            [self makeVideoList:arr];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
        
        [self hideLoading];
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        [self hideLoading];
    }];
}


- (void)makeVideoList:(NSMutableArray *)arr {
    _sectionArr = [NSMutableArray new];
    _dateMarkList = [NSMutableArray new];
    NSMutableArray *dateMarkArr = [NSMutableArray new];
    for (HistoryModel *model in arr) {
        if ([dateMarkArr indexOfObject:model.dateMark] == NSNotFound) {
            [dateMarkArr addObject:model.dateMark];
        }
    }
    NSMutableArray *sectionArr = [NSMutableArray new];
    for (NSString *dateMark in dateMarkArr) {
        NSMutableArray *videoModelArr = [NSMutableArray new];
        for (HistoryModel *model in arr) {
            if ([model.dateMark isEqualToString:dateMark]) {
                [videoModelArr addObject:model];
            }
        }
        [sectionArr addObject:videoModelArr];
    }
    _dateMarkList = dateMarkArr;
    _sectionArr = sectionArr;
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
