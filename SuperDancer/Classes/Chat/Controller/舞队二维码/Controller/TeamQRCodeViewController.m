//
//  TeamQRCodeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/22.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamQRCodeViewController.h"
#import "SGQRCode.h"

@interface TeamQRCodeViewController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *qRCodeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;

@end

@implementation TeamQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"舞队二维码";
    self.view.backgroundColor = kBackgroundColor;
    self.bgView.layer.borderColor = kLineColor.CGColor;
    self.bgView.layer.borderWidth = 1;
    
    self.qRCodeImgView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:NSStringFormat(@"wjwh%@",self.team.teamId) imageViewWidth:self.qRCodeImgView.frame.size.width];
    [self.iconImg setImageWithURL:[NSURL URLWithString:self.team.avatarUrl] placeholder:IMAGE_NAMED(@"avatar_team")];
    self.teamNameLabel.text = self.team.teamName;
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
