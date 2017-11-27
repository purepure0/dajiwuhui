//
//  UserAgreeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "UserAgreeViewController.h"

@interface UserAgreeViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户注册协议";
    [self showLoading];
    NSURL* url = [NSURL URLWithString:@"http://www.dajiwuhui.com/api/member/xieyi"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
