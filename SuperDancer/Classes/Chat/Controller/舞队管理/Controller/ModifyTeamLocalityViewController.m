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
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseLocalityBtn;

@end

@implementation ModifyTeamLocalityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑地区";
    self.view.backgroundColor = kBackgroundColor;
    
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = kLineColor.CGColor;
    
    // 用户没有上传地区，默认使用定位地区
    SDUser *user = [SDUser sharedUser];
    [self.chooseLocalityBtn setTitle:NSStringFormat(@"%@%@%@",user.provinceLocation,user.cityLocation,user.districtLocation) forState:UIControlStateNormal];
    
    
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
}
- (IBAction)chooseLocatityAction:(UIButton *)btn {
    [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
        [btn setTitle:NSStringFormat(@"%@%@%@",province,city,area) forState:UIControlStateNormal];
    }];
}

- (void)finishAction {
    
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
