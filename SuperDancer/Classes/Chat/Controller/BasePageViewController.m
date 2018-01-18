//
//  BasePageViewController.m
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "BasePageViewController.h"

@interface BasePageViewController ()

@end

@implementation BasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)menuView:(WMMenuView *)menu badgeViewAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 15, 15)];
    label.text = @"2";
    label.font = SYSTEM_FONT(11);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 7.5;
    return label;
}

- (CGFloat)menuView:(WMMenuView *)menu titleSizeForState:(WMMenuItemState)state atIndex:(NSInteger)index {
    switch (state) {
        case WMMenuItemStateSelected: {
            return 16;
            break;
        }
        case WMMenuItemStateNormal: {
            return 16;
            break;
        }
    }
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index {
    switch (state) {
        case WMMenuItemStateSelected: {
            return kBaseColor;
            break;
        }
        case WMMenuItemStateNormal: {
            return [UIColor blackColor];
            break;
        }
    }
}

- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu {
    return 3;
}

//- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index {
//    return @"123";
//}

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
