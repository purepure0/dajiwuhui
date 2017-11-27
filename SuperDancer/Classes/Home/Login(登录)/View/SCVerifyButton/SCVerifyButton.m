//
//  SCVerifyButton.m
//  button
//
//  Created by yu on 2016/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SCVerifyButton.h"

#define VERIFY_TIMEOUT 1.0

@interface SCVerifyButton ()

@property (nonatomic, strong) NSTimer *buttonTextTimer;
@property (nonatomic, assign) NSUInteger captchaButtonText;
@property (nonatomic, assign) NSUInteger initialButtonText;

@end

@implementation SCVerifyButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        self.layer.cornerRadius = 3;
//        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kColorHexStr(@"#8C32B4").CGColor;
    }
    return self;
}

- (void)setCountdown:(NSUInteger)countdownTime
{
    _captchaButtonText = countdownTime;
    _initialButtonText = countdownTime;
    [self addTarget:self action:@selector(verifyAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)verifyAction:(SCVerifyButton *)btn
{
    [self startButtonTextTimer];
    btn.backgroundColor = [UIColor clearColor];
    btn.userInteractionEnabled = NO;
    _buttonTextTimer = [NSTimer scheduledTimerWithTimeInterval: VERIFY_TIMEOUT target:self selector:@selector(startButtonTextTimer) userInfo:nil repeats:YES];
}

- (void)startButtonTextTimer
{
    if (_captchaButtonText > 0)
    {
        [UIView performWithoutAnimation:^ {
            self.layer.borderColor = kColorHexStr(@"#BDBDBD").CGColor;
            [self setTitleColor:kColorHexStr(@"#BDBDBD") forState:UIControlStateNormal];
            [self setTitle:[NSString stringWithFormat:@"重新发送(%ld)",_captchaButtonText] forState:UIControlStateNormal];
            [self layoutIfNeeded];
        }];
    }
    else
    {
        [UIView performWithoutAnimation:^ {
            [self setTitle:@"重新发送" forState:UIControlStateNormal];
            [self layoutIfNeeded];
        }];
        [_buttonTextTimer invalidate];
        self.userInteractionEnabled = YES;
        _captchaButtonText = _initialButtonText;
    }
    _captchaButtonText--;
}

@end
