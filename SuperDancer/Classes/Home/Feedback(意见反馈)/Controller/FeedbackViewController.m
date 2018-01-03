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
    self.view.backgroundColor = kBackgroundColor;
    [self setRightItemTitle:@"提交" action:@selector(submitAction)];
    
    self.textView = [[BVTextView alloc] init];
    [self.view addSubview:self.textView];
    
    self.textView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 10)
    .heightIs(kAutoHeight(200));
    
}

- (void)submitAction
{
    if (!self.textView.text.length)
    {
        return;
    }
    [self.hud show:YES];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,kFeedback) parameters:@{@"content":self.textView.text} success:^(id responseObject) {
        [self.hud hide:YES];
        NSString *code = NSStringFormat(@"%@",responseObject[@"code"]);
        if ([code isEqualToString:@"1"]) {
            [self toast:@"提交反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
    }];
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
