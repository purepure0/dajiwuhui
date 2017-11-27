//
//  DancersViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/7.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DancersViewController.h"
#import "DancerListCell.h"
#import "DancerModel.h"
#import "PersonalCenterViewController.h"
#define kDancerCellIdentifier @"DancerListCellIdentifier"

@interface DancersViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *danceList;
@end

@implementation DancersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"舞者";
    
    self.page = 1;
    _danceList = [NSMutableArray new];
    [self initDataSource];
    
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:NIB_NAMED(@"DancerListCell") forCellReuseIdentifier:kDancerCellIdentifier];
    
}

- (void)initDataSource {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *body = @{@"page": @(self.page),
                           @"member_type": @(self.type)
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kDance) parameters:body success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            NSArray *dances = responseObject[@"data"][@"dance"];
            for (NSDictionary *dict in dances) {
                DancerModel *model = [[DancerModel alloc] initDancerModelWithDict:dict];
                [_danceList addObject:model];
                NSLog(@"%@", model.nick_name);
            }
            [_tableView reloadData];
        }
        [hud hide:YES afterDelay:0.2];
    } failure:^(NSError *error) {
        [hud hide:YES afterDelay:0.2];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _danceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DancerListCell *cell = [tableView dequeueReusableCellWithIdentifier:kDancerCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DancerModel *model = _danceList[indexPath.row];
    @weakify(self);
    cell.attentionBlock = ^(DancerModel *model) {
        @strongify(self);
        [self attentionOrCancelAttentionWithModel:model];
    };
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

//取消关注
- (void)attentionOrCancelAttentionWithModel:(DancerModel *)model {
    
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,kAttention) parameters:@{@"uid":model.uid} success:^(id responseObject) {
        PPLog(@"关注/取消关注 == %@",responseObject);
        NSString *code = NSStringFormat(@"%@",responseObject[@"code"]);
        if ([code isEqualToString:@"0"]) {
            model.attentionInfo = responseObject[@"message"];
            [self toast:responseObject[@"message"]];
        }else {
            [self toast:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self toast:error.description];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
