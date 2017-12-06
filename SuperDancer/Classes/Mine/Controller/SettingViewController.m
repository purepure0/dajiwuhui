//
//  SettingViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设 置";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSArray *titles = @[@"个人资料",@"密码修改",@"版本更新",@""];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.textColor = kTextBlackColor;
    cell.textLabel.font = SYSTEM_FONT(16);
    cell.detailTextLabel.font = SYSTEM_FONT(15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 3)
    {
        cell.backgroundColor = [UIColor clearColor];
        UIButton *logoutBtn = [[UIButton alloc] init];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        logoutBtn.titleLabel.font = SYSTEM_FONT(16);
        
        logoutBtn.layer.masksToBounds = YES;
        logoutBtn.layer.cornerRadius = 5;
        logoutBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        logoutBtn.layer.borderWidth = 1;
        logoutBtn.backgroundColor = [UIColor whiteColor];
        [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:logoutBtn];
        
        logoutBtn.sd_layout
        .centerYEqualToView(cell.contentView)
        .heightIs(kAutoHeight(50))
        .leftSpaceToView(cell.contentView, 15)
        .rightSpaceToView(cell.contentView, 15);
    }
    
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"版本:1.0.0";
        
    }
    
    if (indexPath.row <= 1) {
        UIImageView *arrowImg = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"right_arrow")];
        cell.accessoryView = arrowImg;
    }
    
    
    return cell;
}

- (void)logoutAction
{
    [self.users logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 3 ? kAutoHeight(100):kAutoHeight(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
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
