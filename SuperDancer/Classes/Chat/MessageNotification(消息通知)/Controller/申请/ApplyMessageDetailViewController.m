//
//  ApplyMessageDetailViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ApplyMessageDetailViewController.h"
#import "ApplyDetailCell.h"
@interface ApplyMessageDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *data;
@end

@implementation ApplyMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data = @[
              @[@{@"icon": @"pic1", @"nickname": @"舞者名称007", @"city": @"菏泽"},
                @{@"title": @"舞队名片", @"content": @"未设置"}],
              @[@{@"title": @"手机号码", @"content": @"18818881888"},
                @{@"title": @"所在地区", @"content": @"山东省菏泽市牡丹区"}],
              @[@{@"title": @"所在地区", @"content": @"爱好广场舞、民族舞，爱好广场舞、民族舞，爱好广场舞、民族舞"}]
              ];
    self.fd_prefersNavigationBarHidden = YES;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyDetailCell *cell = [ApplyDetailCell initTableViewCellWith:tableView indexPath:indexPath];
    
    NSDictionary *dic = _data[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell updateFirstCellWithData:dic];
    }else if (indexPath.section == 2) {
        [cell updateThirdCellWithData:dic];
    }else {
        [cell updateSecondCellWithData:dic];
    }
    
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 60;
    }
    return 0.1;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
        CGFloat width = (kScreenSize.width - 45) / 2;
        UIButton *refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, width, 45)];
        [refuseBtn setTitle:@"拒 绝" forState:UIControlStateNormal];
        [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        refuseBtn.layer.masksToBounds = YES;
        refuseBtn.layer.cornerRadius = 3;
        refuseBtn.layer.borderWidth = 1;
        refuseBtn.layer.borderColor = kLineColor.CGColor;
        [view addSubview:refuseBtn];
        
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 * 2 + width, 15, width, 45)];
        [agreeBtn setTitle:@"同 意" forState:UIControlStateNormal];
        agreeBtn.backgroundColor = kColorRGB(75, 169, 39);
        agreeBtn.layer.masksToBounds = YES;
        agreeBtn .layer.cornerRadius = 3;
        [view addSubview:agreeBtn];
        return view;
    }
    return nil;
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
