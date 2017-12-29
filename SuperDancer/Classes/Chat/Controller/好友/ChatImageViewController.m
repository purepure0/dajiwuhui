//
//  ChatImageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ChatImageViewController.h"
#import "ImageScroll.h"
@interface ChatImageViewController ()
@property (nonatomic, strong)ImageScroll *imgS;
@property (nonatomic, strong)NSString *imgUrl;
@end

@implementation ChatImageViewController

- (instancetype)initWithImageUrl:(NSString *)imgUrl {
    if (self = [super init]) {
        _imgUrl = imgUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    _imgS = [[ImageScroll alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) imageUrl:_imgUrl];
    __weak typeof(self) weakSelf = self;
    _imgS.dismissBlock = ^() {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.view addSubview:_imgS];
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
