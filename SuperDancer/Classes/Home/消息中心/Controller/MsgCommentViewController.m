//
//  MsgCommentViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MsgCommentViewController.h"
#import "MsgCommentModel.h"
#import "MsgCommentCell.h"
#import "MovePlayerViewController.h"
#define kMsgCommentCellIdentifier @"MsgCommentCellIdentifier"

@interface MsgCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *commentList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MsgCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _commentList = [NSMutableArray new];
    self.page = 1;
    [self initDataSource];
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [_commentList removeAllObjects];
        [self initDataSource];
    }];
    self.tableView.mj_header = self.header;
    
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    self.tableView.mj_footer = self.footer;
    
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:NIB_NAMED(@"MsgCommentCell") forCellReuseIdentifier:kMsgCommentCellIdentifier];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kMsgCommentCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MsgCommentModel *model = _commentList[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCommentModel *model = _commentList[indexPath.row];
    CGRect rect = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    return 70 + rect.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MsgCommentModel *model = _commentList[indexPath.row];
//    MovePlayerViewController *player = [[MovePlayerViewController alloc] init];
//    player.vid = model.vid;
    
}


- (void)initDataSource {
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kMyVideoComment) parameters:@{@"page": @(self.page)} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"data"][@"res"][@"list"];
            for (NSDictionary *dict in arr) {
                MsgCommentModel *model = [[MsgCommentModel alloc] initMsgCommentModelWithDict:dict];
                [_commentList addObject:model];
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
