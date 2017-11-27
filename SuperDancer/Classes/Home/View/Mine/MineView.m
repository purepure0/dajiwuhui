//
//  MineView.m
//  SuperDancer
//
//  Created by yu on 2017/10/6.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MineView.h"

@interface MineView ()

@property (nonatomic, strong) UIButton *switchBtn;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UIImageView *autoWidthViewsContainer;

@property (nonatomic, strong) UIView *threeViewsContainer;

@property (nonatomic, strong) NSMutableArray *temp;


@end

@implementation MineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.backgroundColor = [kColorRGB(140, 50, 180) colorWithAlphaComponent:0.45];
        effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:effectView];
        
        // 切换账户
        _switchBtn = [[UIButton alloc] init];
        [self addSubview:_switchBtn];
        [_switchBtn setImage:IMAGE_NAMED(@"Shape") forState:UIControlStateNormal];
        [_switchBtn setTitle:@"切换账户" forState:UIControlStateNormal];
        [_switchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchAccountAction) forControlEvents:UIControlEventTouchUpInside];
        _switchBtn.titleLabel.font = SYSTEM_FONT(12);
        _switchBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // 头像
//        _avatarBtn = [[UIButton alloc] init];
//        [self addSubview:_avatarBtn];
////        [_avatarBtn setTitle:@"点击登录" forState:UIControlStateNormal];
//        [_avatarBtn setImage:IMAGE_NAMED(@"placeholder_img") forState:UIControlStateNormal];
//        [_avatarBtn setTitleColor:kColorHexStr(@"#212121") forState:UIControlStateNormal];
//        [_avatarBtn setBackgroundColor:[UIColor whiteColor]];
//        _avatarBtn.titleLabel.font = Font_NAME_SIZE(@"PingFangSC-Semibold", 12);
//        _avatarBtn.layer.masksToBounds = YES;
//        _avatarBtn.layer.cornerRadius = 50;
//        _avatarBtn.layer.borderWidth = 3;
//        _avatarBtn.layer.borderColor = [kColorHexStr(@"#D6D6D6") colorWithAlphaComponent:0.36].CGColor;
//        [_avatarBtn addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        _avatarImageView = [[UIImageView alloc] init];
        [self addSubview:_avatarImageView];
        _avatarImageView.image = IMAGE_NAMED(@"placeholder_img");
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 50;
        _avatarImageView.layer.borderWidth = 3;
        _avatarImageView.layer.borderColor = [kColorHexStr(@"#D6D6D6") colorWithAlphaComponent:0.36].CGColor;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction)];
        [_avatarImageView addGestureRecognizer:tap];
        
        // 昵称
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.text = @"未登录";
        _nicknameLabel.textColor = [UIColor whiteColor];
        _nicknameLabel.textAlignment = NSTextAlignmentCenter;
        _nicknameLabel.font = Font_NAME_SIZE(@"PingFangSC-Semibold", 16);
        [self addSubview:_nicknameLabel];
        
        // 四个按钮
        _autoWidthViewsContainer = [[UIImageView alloc] init];
        _autoWidthViewsContainer.image = IMAGE_NAMED(@"line_frame");
        _autoWidthViewsContainer.userInteractionEnabled = YES;
        _autoWidthViewsContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_autoWidthViewsContainer];
        
        NSArray *titles = @[@"我的收藏",@"消息中心",@"浏览记录",@"离线缓存"];
        NSArray *images = @[@"收 藏",@"消息",@"浏览记录",@"缓存"];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [_autoWidthViewsContainer addSubview:button];
            
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = SYSTEM_FONT(14);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            button.tag = i + 100;
            
            [button addTarget:self action:@selector(fourBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            // 设置button的图片的约束
            button.imageView.sd_layout
            .widthRatioToView(button, 0.15)
            .topSpaceToView(button, 20)
            .centerXEqualToView(button)
            .heightRatioToView(button, 0.25);
            
            // 设置button的label的约束
            button.titleLabel.sd_layout
            .topSpaceToView(button.imageView, 10)
            .bottomSpaceToView(button, 19)
            .leftSpaceToView(button, 0)
            .rightSpaceToView(button, 0);
            
            // 设置高度约束
            button.sd_layout.autoHeightRatio(0.6);
            [temp addObject:button];
        }
    
        // 三个按钮
        _threeViewsContainer = [[UIView alloc] init];
//        _threeViewsContainer.backgroundColor = [UIColor orangeColor];
        [self addSubview:_threeViewsContainer];
        
        NSArray *titleArray = @[@"用户协议",@"关于我们",@"意见反馈"];
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0 ; i < titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [_threeViewsContainer addSubview:btn];
            
//            btn.backgroundColor = [UIColor redColor];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = SYSTEM_FONT(12);
            btn.tag = i + 200;
            [btn addTarget:self action:@selector(threeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.sd_layout.autoHeightRatio(0.4);
            [array addObject:btn];
        }
        
        
#pragma mark - 适配
        _switchBtn.sd_layout
        .rightSpaceToView(self, 13)
        .topSpaceToView(self, 30)
        .widthIs(70);
        
        _switchBtn.imageView.sd_layout
        .leftSpaceToView(_switchBtn, 0)
        .centerYEqualToView(_switchBtn)
        .heightIs(12)
        .autoWidthRatio(5/4);
        
        _switchBtn.titleLabel.sd_layout
        .rightSpaceToView(_switchBtn, 0)
        .centerYEqualToView(_switchBtn)
        .leftSpaceToView(_switchBtn.imageView, 5);
        
        _avatarImageView.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self, 54)
        .widthIs(100)
        .heightEqualToWidth();
        
        _nicknameLabel.sd_layout
        .topSpaceToView(_avatarImageView, 17)
        .centerXEqualToView(_avatarImageView)
        .heightIs(22)
        .widthIs(150);
        
        _autoWidthViewsContainer.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_nicknameLabel, 35);
        
        [_autoWidthViewsContainer setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:2 verticalMargin:0.5 horizontalMargin:0.5 verticalEdgeInset:0.5 horizontalEdgeInset:0];
        
        
        _threeViewsContainer.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomSpaceToView(self, 20);
        
        [_threeViewsContainer setupAutoWidthFlowItems:[array copy] withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:15 verticalEdgeInset:0 horizontalEdgeInset:20];
    }
    return self;
}



- (void)avatarAction
{
    if (self.avatarBtnBlock)
    {   
        self.avatarBtnBlock();
    }
}

- (void)fourBtnAction:(UIButton *)btn
{
    if (self.fourBtnBlock)
    {
        self.fourBtnBlock(btn.tag);
    }
}

- (void)threeBtnAction:(UIButton *)btn
{
    if (self.threeBtnBlock)
    {
        self.threeBtnBlock(btn.tag);
    }
}

- (void)switchAccountAction {
    if (self.switchAccountBlock) {
        self.switchAccountBlock();
    }
}

- (void)updateView {
    SDUser *user = [SDUser sharedUser];
//    if (user.userId.length == 0) return;
    
    if (user.nickName.length > 0) {
        _nicknameLabel.text = user.nickName;
    }else {
        _nicknameLabel.text = @"未登录";
    }
    
    if (user.avatarURL > 0) {
        [_avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholder:[UIImage imageNamed:@"placeholder_img"]];
    }else {
        _avatarImageView.image = [UIImage imageNamed:@"placeholder_img"];
    }
    
}

@end

