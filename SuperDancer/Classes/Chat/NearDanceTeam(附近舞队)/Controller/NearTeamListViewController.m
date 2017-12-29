//
//  NearTeamListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "NearTeamListViewController.h"
#import "NearTeamCell.h"
#import "NearbyTeamModel.h"
#import "QRCodeTeamInfoViewController.h"

@interface NearTeamListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *nearbyList;

@end

static NSString *kNearTeamCell = @"kNearTeamCell";

@implementation NearTeamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"附 近";
    self.view.backgroundColor = kBackgroundColor;
    [self.tableView registerNib:NIB_NAMED(@"NearTeamCell") forCellReuseIdentifier:kNearTeamCell];
    [self fetchNearbyList];
}

- (void)fetchNearbyList {
    [self.hud show:YES];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,kNearbyTeam) parameters:@{@"lat":self.users.latLocation,@"lon":self.users.lonLocation,@"raidus":@"10000"} success:^(id responseObject) {
        [self.hud hide:YES];
//        PPLog(@"NearbyTeamList == %@",[self jsonToString:responseObject]);
        NSDictionary *res = responseObject[@"data"][@"res"];
        NSArray *teams = res[@"team"];
        self.nearbyList = [NSMutableArray array];
        for (NSDictionary *dict in teams) {
            NearbyTeamModel *model = [[NearbyTeamModel alloc] init];
            model.distance = dict[@"distance"];
            NSArray *tinfos = dict[@"team"][@"tinfos"];
            for (NSDictionary *info in tinfos) {
                model.tname = info[@"tname"];
                model.owner = info[@"owner"];
                model.icon = info[@"icon"];
                model.tid = info[@"tid"];
            }
            [self.nearbyList addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.hud hide:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !section ? self.nearbyList.count:3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:kNearTeamCell];
    if (!indexPath.section) {
        NearbyTeamModel *model = self.nearbyList[indexPath.row];
        [cell setModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = section ? @"附近舞者":@"附近舞队";
    titleLabel.font = Font_NAME_SIZE(@"FZLTHJW--GB1-0", 17);
    titleLabel.textColor = UIColorHex(@"#333333");
    [whiteView addSubview:titleLabel];
    
    whiteView.sd_layout
    .leftEqualToView(bgView)
    .bottomEqualToView(bgView)
    .widthRatioToView(bgView, 1)
    .heightIs(45);
    
    titleLabel.sd_layout
    .leftSpaceToView(whiteView, 15)
    .rightSpaceToView(whiteView, 15)
    .centerYEqualToView(whiteView)
    .heightRatioToView(whiteView, 1);
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NearbyTeamModel *model = self.nearbyList[indexPath.row];
        QRCodeTeamInfoViewController *QRC = [[QRCodeTeamInfoViewController alloc] init];
        QRC.teamID = NSStringFormat(@"%@",model.tid);
        [self.navigationController pushViewController:QRC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"->申请加入[舞者]" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确 定", nil];
        [alert show];
    }
}


@end
