//
//  PublicNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "PublicNoticeDetailViewController.h"

@interface PublicNoticeDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PublicNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息详情";
    [self showLoading];
    _webView.delegate = self;
    [_webView loadHTMLString:@"<p class='p1'>系统公告<p><p class='p2'>2017-10-10 10:30:20<p><p class='p3'>系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统，公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告，系统公告系统公告系统公告。 系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统，公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告，系统公告系统公告系统公告。</p><p class='p3'>系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统，公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告，系统公告系统公告系统公告。 系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统，公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告系统公告，系统公告系统公告系统公告。</p><style>.p3{text-indent:2em}</style>" baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
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
