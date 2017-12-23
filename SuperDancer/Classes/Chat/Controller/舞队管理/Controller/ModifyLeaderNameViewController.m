//
//  ModifyLeaderNameViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ModifyLeaderNameViewController.h"

@interface ModifyLeaderNameViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ModifyLeaderNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑领队名称";
    self.view.backgroundColor = kBackgroundColor;
    
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = kLineColor.CGColor;
    
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
}

- (void)finishAction {
    
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
