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
@property (nonatomic, strong)UIView *fatherView;
@property (nonatomic, strong)UIButton *playOrPauseBtn;

@end

@implementation ChatVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    
    _fatherView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_fatherView];
    
    _playerModel = [[ZFPlayerModel alloc] init];
    _playerModel.videoURL = [NSURL URLWithString:_videoObj.url];
    _playerModel.placeholderImageURLString = _videoObj.coverUrl;
    _playerModel.fatherView = _fatherView;
    
    
    self.playerView = [[ZFPlayerView alloc] init];
    [_playerView playerControlView:nil playerModel:_playerModel];
    _playerView.delegate = self;
    _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    [_playerView autoPlayTheVideo];

}

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
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
