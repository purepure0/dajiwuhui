//
//  ChatVideoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ChatVideoViewController.h"
#import "ZFPlayer.h"
@interface ChatVideoViewController ()<ZFPlayerDelegate>
@property (nonatomic, strong)ZFPlayerView *playerView;
@property (nonatomic, strong)ZFPlayerModel *playerModel;
@end

@implementation ChatVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _playerView = [ZFPlayerView sharedPlayerView];
    _playerView.delegate = self;
    _playerView.cellPlayerOnCenter = NO;
    _playerView.stopPlayWhileCellNotVisable = YES;
    
    _playerModel = [[ZFPlayerModel alloc] init];
    _playerModel.title = _playerModel.title;
//    _playerModel.videoURL
    
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
