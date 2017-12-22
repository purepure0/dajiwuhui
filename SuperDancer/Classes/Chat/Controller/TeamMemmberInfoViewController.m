//
//  TeamMemmberInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamMemmberInfoViewController.h"
#import "TeamJoinCell.h"
@interface TeamMemmberInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *data;
@end

@implementation TeamMemmberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            index = 0;
        }else {
            index = 1;
        }
    }else if (indexPath.section == 2) {
        index = 2;
    }else {
        index = 1;
    }
    TeamJoinCell *cell = [TeamJoinCell initWithTableView:tableView andIndex:index];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"pic1"];
            cell.nicknameLabel.text = @"舞者名称";
            cell.cityLabel.text = @"菏泽";
        }else {
            cell.leftLabel.text = @"舞队名片";
            cell.rightLabel.text = @"未设置";
            [cell showRigthArrow:NO];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"手机号码";
            cell.rightLabel.text = @"188 6666 8888";
        }else {
            cell.leftLabel.text = @"所在地区";
            cell.rightLabel.text = @"山东省菏泽市牡丹区";
        }
        [cell showRigthArrow:NO];
    }else if (indexPath.section == 2) {
        cell.topLabel.text = @"个人介绍";
        cell.bottomLabel.text = @"爱好广场舞、民族舞";
    }else {
        cell.leftLabel.text = @"发言记录";
        [cell showRigthArrow:NO];
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != 3) {
        return 10;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
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
