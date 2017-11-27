//
//  FeedbackViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FeedbackViewController.h"

#import "BVTextView.h"

@interface FeedbackViewController ()

@property (nonatomic, strong) BVTextView *textView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    
    self.textView = [[BVTextView alloc] init];
    [self.view addSubview:self.textView];
    
    self.textView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 10)
    .heightIs(200);
    
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
