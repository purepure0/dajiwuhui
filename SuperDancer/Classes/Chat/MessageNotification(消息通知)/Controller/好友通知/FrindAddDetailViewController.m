//
//  FrindAddDetailViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FrindAddDetailViewController.h"
#import "FriendNotiDetailCell.h"
@interface FrindAddDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FrindAddDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.tableFooterView = [UIView new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendNotiDetailCell *cell = [FriendNotiDetailCell initTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.row == 0) {
        [cell updateFirstCellWithAvatarUrl:@"" nickname:@"" city:@""];
    }else {
        [cell updateSecondCellWithpersonIntro:@""];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 170;
    }else{
        return 125;
    }
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
