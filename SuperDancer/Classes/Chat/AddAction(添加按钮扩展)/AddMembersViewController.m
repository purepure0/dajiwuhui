//
//  AddMembersViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AddMembersViewController.h"

@interface AddMembersViewController ()

@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加成员";
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
    [_members addObject:@""];
}

- (void)finishAction {
    if (_finished) {
        _finished();
    }
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
