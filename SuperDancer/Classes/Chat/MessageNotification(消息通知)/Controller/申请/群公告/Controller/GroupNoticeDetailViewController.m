//
//  GroupNoticeDetailViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//  公告详情

#import "GroupNoticeDetailViewController.h"

@interface GroupNoticeDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *bottomView;

@end

@implementation GroupNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"公告详情";
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:self.containerView];
    [self.scrollView setupAutoContentSizeWithBottomView:self.containerView bottomMargin:0];
    
    [self setupAllSubviews];
    
    self.containerView.sd_layout
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .topSpaceToView(self.scrollView, 10);
    
    [self.containerView setupAutoHeightWithBottomView:_bottomView bottomMargin:10];
    
}

- (void)setupAllSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = kTextBlackColor;
    titleLabel.text = @"舞队公告";
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.text = @"发布时间：2017-10-10";
    
    UILabel *readNumLabel = [[UILabel alloc] init];
    readNumLabel.font = [UIFont systemFontOfSize:14];
    readNumLabel.textAlignment = NSTextAlignmentRight;
    readNumLabel.textColor = kBaseColor;
    readNumLabel.text = @"2人已读";
    _bottomView = readNumLabel;
    
    [self.containerView sd_addSubviews:@[titleLabel,timeLabel,readNumLabel]];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.containerView, 15)
    .topSpaceToView(self.containerView, 10)
    .widthRatioToView(self.containerView, 0.5)
    .heightIs(25);
    
    timeLabel.sd_layout
    .leftEqualToView(titleLabel)
    .topSpaceToView(titleLabel, 10)
    .widthRatioToView(titleLabel, 1)
    .heightIs(20);
    
    readNumLabel.sd_layout
    .rightSpaceToView(self.containerView, 15)
    .centerYEqualToView(timeLabel)
    .widthIs(100)
    .heightRatioToView(timeLabel, 1);
    
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
