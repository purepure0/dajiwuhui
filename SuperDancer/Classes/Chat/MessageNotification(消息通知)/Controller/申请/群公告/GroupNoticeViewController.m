//
//  GroupNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "GroupNoticeViewController.h"
#import "PublishNoticeViewController.h"

@interface GroupNoticeViewController ()

@end

@implementation GroupNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"舞队公告";
    [self setRightItemTitle:@"发布" action:@selector(publishAction)];
}

- (void)publishAction {
    PublishNoticeViewController *pn = [[PublishNoticeViewController alloc] init];
    [self.navigationController pushViewController:pn animated:YES];
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
