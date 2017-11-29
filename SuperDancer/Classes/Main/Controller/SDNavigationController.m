//
//  SDNavigationController.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDNavigationController.h"
#import "UIBarButtonItem+SCItem.h"

@interface SDNavigationController ()

@end

@implementation SDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize {
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kTextBlackColor,NSFontAttributeName:[UIFont systemFontOfSize:19]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav_back_black"] target:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
//        [self.navigationBar setBackIndicatorImage:[[UIImage alloc]init]];
//        [self.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage alloc] init]];
//        viewController.navigationItem.leftBarButtonItem = backButtonItem;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 返回
- (void)returnAction {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
