//
//  SDChatPageViewController.m
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "SDChatPageViewController.h"
#import <WMPageController.h>
#import "MessageNotiViewController.h"
#import "ContactsViewController.h"
#import "ConversationViewController.h"
#import "ThreeRightView.h"
#import "CreatDanceTeamViewController.h"
#import "SearchTeamViewController.h"
#import "SessionListViewController.h"
#import "NearTeamViewController.h"
#import "AddFriendViewController.h"
#import "SDNavigationController.h"
#import "LoginViewController.h"
@interface SDChatPageViewController ()<WMPageControllerDelegate, WMPageControllerDataSource, WMMenuViewDelegate>
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong)UIView *loginView;
@end

@implementation SDChatPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initPageController];
    [self.rightBtn setBackgroundColor:[UIColor redColor]];
    [self setRightImageNamed:@"wd_nav_btn_add" action:@selector(createTeamAction)];
}

- (UIView *)loginView {
    if (_loginView == nil) {
        _loginView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loginView.backgroundColor = [UIColor whiteColor];
        _loginView.userInteractionEnabled = YES;
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width / 2 - 50, kScreenSize.height - 200, 100, 45)];
        [loginBtn setTitle:@"去登陆" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.layer.masksToBounds = YES;
        loginBtn.layer.cornerRadius = 2;
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = kColorHexStr(@"#8C32B4").CGColor;
        [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:loginBtn];
    }
    return _loginView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([SDUser sharedUser].userId == nil) {
        [self.view addSubview:self.loginView];
        [self.view bringSubviewToFront:self.loginView];
    }else {
        [self.loginView removeFromSuperview];
    }
    [MobClick event:@"click10"];
    
}

- (void)goLogin {
    LoginViewController *login = [[LoginViewController alloc] init];
    SDNavigationController *nav = [[SDNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)createTeamAction
{
    //加号按钮
    ThreeRightView *view = [[ThreeRightView alloc]initCustomImageArray:@[@"001",@"2.jpg",@"2.jpg"] textArray:@[@"创建舞队",@"查找舞队",@"添加好友",] selfFrame:CGRectMake(kScreenWidth-155,49,150,165)];
    view.selectRowBlock = ^(NSString *row) {
        switch (row.intValue) {
            case 0:
            { CreatDanceTeamViewController *CDTVC = [[CreatDanceTeamViewController alloc]init];
                [self.navigationController pushViewController:CDTVC animated:YES];
            }
                break;
            case 1:
            {
                SearchTeamViewController *STVC = [[SearchTeamViewController alloc]init];
                [self.navigationController pushViewController:STVC animated:YES];
            }
                break;
            case 2:{
                AddFriendViewController *af = [[AddFriendViewController alloc] init];
                [self.navigationController pushViewController:af animated:YES];
            }
                break;
            default:
                break;
        }
        
    };
    [view show:YES];
}

- (void)initPageController
{
    
    self.pageController = [[WMPageController alloc] initWithViewControllerClasses:@[[SessionListViewController class],[ContactsViewController class],[MessageNotiViewController class]] andTheirTitles:@[@"会话",@"联系人",@"通知"]];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.titleSizeNormal = 16;
    self.pageController.titleSizeSelected = 16;
    self.pageController.titleColorNormal = kColorRGB(33, 33, 33);
    self.pageController.titleColorSelected = kColorRGB(140, 50, 180);
    
    self.pageController.view.frame = self.view.frame;
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
    
    self.pageController.menuView.backgroundColor = [UIColor whiteColor];
    [self.pageController.menuView setStyle:WMMenuViewStyleLine];
    self.pageController.menuView.progressWidths = @[@(10),@(10),@(10)];
    self.pageController.menuView.progressHeight = 3;
    self.pageController.menuView.progressViewIsNaughty = YES;
    [self.pageController.menuView setLayoutMode:WMMenuViewLayoutModeCenter];
    self.pageController.menuView.lineColor = kColorRGB(140, 50, 180);
    self.pageController.menuView.contentMargin = 0;
    self.navigationItem.titleView = self.pageController.menuView;
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, 200, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return pageController.view.frame;
}

//- (UIView *)

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
