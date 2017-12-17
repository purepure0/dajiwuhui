//
//  NearTeamListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "NearTeamListViewController.h"
#import "NearTeamCell.h"
#import "NearADCell.h"

@interface NearTeamListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *kNearTeamCell = @"kNearTeamCell";
static NSString *kNearADCell = @"kNearADCell";

@implementation NearTeamListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"附 近";
    self.view.backgroundColor = kBackgroundColor;
    [self.tableView registerNib:NIB_NAMED(@"NearTeamCell") forCellReuseIdentifier:kNearTeamCell];
    [self.tableView registerNib:NIB_NAMED(@"NearADCell") forCellReuseIdentifier:kNearADCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && !indexPath.row) {
        NearADCell *cell = [tableView dequeueReusableCellWithIdentifier:kNearADCell];
        return cell;
    } else {
        NearTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:kNearTeamCell];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && !indexPath.row) {
        return 200;
    } else {
        return 70;
    }
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
