//
//  ShoppingHomeViewController.m
//  SuperDancer
//
//  Created by 王司坤 on 2018/1/18.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "ShoppingHomeViewController.h"
#import "SDCycleScrollView.h"


@interface ShoppingHomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *shoppingMainTableView;
@property (strong,nonatomic) UIView *tabelViewHeaderViewBackView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollerView;

@end

@implementation ShoppingHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableHeaderView];
}

-(void)initTableHeaderView{
    
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
