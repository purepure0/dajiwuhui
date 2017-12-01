//
//  SDMineViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDMineViewController.h"

#import "SettingViewController.h"
#import "MineHandleCell.h"

#import "MyCollectionViewController.h"
//#import "MsgCommentViewController.h"
#import "MsgCenterViewController.h"
#import "BrowsingHistoryViewController.h"
#import "DownloadViewController.h"
#import "MovieDownloadViewController.h"

#import "UserAgreeViewController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*1)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT kAutoHeight(200)
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface SDMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 导航栏
@property (nonatomic, strong) UIView *topView;
//table view头视图
@property (nonatomic, strong) UIView *headerView;
// 头像
@property (nonatomic, strong) UIButton *portraitButton;
// 昵称
@property (nonatomic, strong) UILabel *nicknameLabel;

// 设置
@property (nonatomic, strong) UIButton *rightItem;
// 我的
@property (nonatomic, strong) UILabel *mineLabel;
@property (nonatomic, strong) UIView *lineView;

@end

static NSString *kMineHandleCellIdentifier = @"MineHandleCellIdentifier";
static NSString *kDefaultCellIdentifier = @"DefaultCellIdentifier";

@implementation SDMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
    [self.tableView registerNib:NIB_NAMED(@"MineHandleCell") forCellReuseIdentifier:kMineHandleCellIdentifier];
    [self setupHeaderView];
    [self setupTopView];
}

- (void)setupTopView
{
    UIView *topView = [[UIView alloc] init];
    _topView = topView;
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = [UIColor clearColor];
    [topView addSubview:lineView];
    
    UILabel *mineLabel = [[UILabel alloc] init];
    _mineLabel = mineLabel;
    mineLabel.text = @"我的";
    mineLabel.font = SYSTEM_FONT(19);
    mineLabel.textColor = [UIColor clearColor];
    mineLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:mineLabel];
    
    UIButton *rightItem = [[UIButton alloc] init];
    _rightItem = rightItem;
    [rightItem setTitle:@"设置" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = SYSTEM_FONT(16);
    [rightItem addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightItem];
    
#pragma mark-
    topView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(64);
    
    lineView.sd_layout
    .leftEqualToView(topView)
    .rightEqualToView(topView)
    .bottomEqualToView(topView)
    .heightIs(0.5);
    
    mineLabel.sd_layout
    .centerXEqualToView(topView)
    .bottomSpaceToView(topView, 7)
    .widthIs(100)
    .heightIs(30);
    
    rightItem.sd_layout
    .rightSpaceToView(topView, 5)
    .centerYEqualToView(mineLabel)
    .heightRatioToView(mineLabel, 1)
    .widthIs(50);
    
}

- (void)settingAction
{
    SettingViewController *setting = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)setupHeaderView
{
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [kBaseColor colorWithAlphaComponent:0.5];
    [_tableView addSubview:_headerView];
    
    _portraitButton = [[UIButton alloc] init];
    _portraitButton.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_portraitButton];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.text = @"大集舞会";
    [_headerView addSubview:_nicknameLabel];
    
#pragma mark -
    _headerView.sd_layout
    .centerXEqualToView(_tableView)
    .widthIs(kScreenWidth)
    .heightIs(IMAGE_HEIGHT)
    .yIs(-IMAGE_HEIGHT);
    
    _portraitButton.sd_cornerRadius = @(kAutoWidth(80)/2);
    _portraitButton.sd_layout
    .centerXEqualToView(_headerView)
    .centerYEqualToView(_headerView)
    .widthIs(kAutoWidth(80))
    .heightEqualToWidth();
    
    [_nicknameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nicknameLabel.sd_layout
    .topSpaceToView(_portraitButton, 10)
    .centerXEqualToView(_headerView)
    .heightIs(25);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
//        PPLog(@"***==%lf",alpha);
        _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
        _mineLabel.textColor = [kTextBlackColor colorWithAlphaComponent:alpha];
        [_rightItem setTitleColor:kTextBlackColor  forState:UIControlStateNormal];
        _lineView.backgroundColor = [kTextGrayColor colorWithAlphaComponent:alpha];
        [self setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _mineLabel.textColor = [UIColor clearColor];
        _lineView.backgroundColor = [UIColor clearColor];
        [_rightItem setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    // 改变图片框的大小 (上滑的时候不改变)
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        self.headerView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}

#pragma mark -table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? 3:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDefaultCellIdentifier];
        }
        NSArray *titles = @[@"用户协议",@"关于我们",@"意见反馈"];
        cell.textLabel.text = titles[indexPath.row];
        cell.textLabel.textColor = kTextBlackColor;
        
        return cell;
    } else {
        MineHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineHandleCellIdentifier];
        [cell setHandleBlock:^(NSInteger index) {
            switch (index) {
                case 1:
                    [self pushToNextPageWithClass:[MyCollectionViewController class]];
                    break;
                case 2:
                    [self pushToNextPageWithClass:[MsgCenterViewController class]];
                    break;
                case 3:
                     [self pushToNextPageWithClass:[BrowsingHistoryViewController class]];
                    break;
                case 4:
                    [self pushToNextPageWithClass:[MovieDownloadViewController class]];
                    break;
                default:
                    break;
            }
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        if (indexPath.row == 0) {
            [self pushToNextPageWithClass:[UserAgreeViewController class]];
        } else if (indexPath.row == 1) {
            [self pushToNextPageWithClass:[AboutUsViewController class]];
        } else {
            [self pushToNextPageWithClass:[FeedbackViewController class]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? 50 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark -push

- (void)pushToNextPageWithClass:(Class)class
{
    [self.navigationController pushViewController:[self getViewControllerFromClass:class] animated:YES];
}

- (UIViewController *)getViewControllerFromClass:(Class)class {
    return [[class alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
