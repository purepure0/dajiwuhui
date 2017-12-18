//
//  NearTeamViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "NearTeamViewController.h"

#import "NearTeamListViewController.h"

@interface NearTeamViewController ()

@end

@implementation NearTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"附 近";
    self.view.backgroundColor = kBackgroundColor;
}
- (IBAction)nearAction:(id)sender {
    NearTeamListViewController *list = [[NearTeamListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
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
