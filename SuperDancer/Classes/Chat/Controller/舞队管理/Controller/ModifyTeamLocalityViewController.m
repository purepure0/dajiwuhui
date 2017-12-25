//
//  ModifyTeamLocalityViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ModifyTeamLocalityViewController.h"
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"
@interface ModifyTeamLocalityViewController ()
{
//    NSString *_locality;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseLocalityBtn;
@property (nonatomic, strong) NSMutableArray *localityArray;

@end

@implementation ModifyTeamLocalityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑地区";
    self.view.backgroundColor = kBackgroundColor;
    
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = kLineColor.CGColor;
    
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
    [self.chooseLocalityBtn setTitle:self.locality forState:UIControlStateNormal];
}

- (IBAction)chooseLocatityAction:(UIButton *)btn {
    [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
        self.locality = NSStringFormat(@"%@,%@,%@",province,city,area);
        NSString *locality = [self.locality stringByReplacingOccurrencesOfString:@"," withString:@""];
        PPLog(@"%@",locality);
        [btn setTitle:locality forState:UIControlStateNormal];
    }];
}

- (void)finishAction {
    NSDictionary *locality = @{@"locality": self.locality};
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[locality] options:0 error:nil];
    NSString *loc = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[NIMSDK sharedSDK].teamManager updateTeamCustomInfo:loc teamId:self.team.teamId completion:^(NSError * _Nullable error) {
        if (!error) {
            [self toast:@"编辑地址成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
