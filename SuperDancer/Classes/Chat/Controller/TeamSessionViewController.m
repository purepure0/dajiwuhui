//
//  TeamSessionViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamSessionViewController.h"
#import <NIMCustomLeftBarView.h>
#import "TeamInfoViewController.h"
#import "TeamMemmberInfoViewController.h"
@interface TeamSessionViewController ()

@end

@implementation TeamSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCustomNav];
}

- (void)setupCustomNav {
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    

    NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftBarView.badgeView = nil;
    leftBarView.userInteractionEnabled = YES;
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back_black"]];
    [leftBarView addSubview:img];
    [leftBarView addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightBtn addTarget:self action:@selector(teamInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}


- (void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)teamInfo:(UIButton *)btn {
    NSLog(@"teamInfo");
    TeamInfoViewController *teamInfo = [[TeamInfoViewController alloc] init];
    teamInfo.teamID = _teamID;
    teamInfo.team = _team;
    [self.navigationController pushViewController:teamInfo animated:YES];
    
}
- (BOOL)onTapAvatar:(NSString *)userId {
    NSLog(@"点击头像：%@", userId);
    TeamMemmberInfoViewController *member = [[TeamMemmberInfoViewController alloc] init];
    [self.navigationController pushViewController:member animated:YES];
    return YES;
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
