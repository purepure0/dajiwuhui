//
//  DJWYAlertView.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DJWYAlertView.h"
#import "UIBounceButton.h"
#import <Accelerate/Accelerate.h>

@interface DJWYAlertView()
@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, strong) UIView *alertContentView;
@property (nonatomic,copy) clickHandle knownButtonClick;//点击 知道了 按钮
@property (nonatomic,copy) clickHandle rightButtonClick;
@property (nonatomic,copy) clickHandle leftButtonClick;
@property (nonatomic,copy) clickHandle midButtonClick;
@property (nonatomic,strong)UIBounceButton *midButton;

@end

@implementation DJWYAlertView

+ (instancetype)sharedInstance {
    static DJWYAlertView *sharedDJWYAlertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDJWYAlertView = [[self alloc] init];
    });
    return sharedDJWYAlertView;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)showOneButtonWithTitleWithMidButton:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle middleButtonTitle:(NSString *)middleButtonTitle imageButton:(UIImage *)imageButton  click:(clickHandle)click knownclick:(clickHandle)knownclick{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    [alertView configAlertViewPropertyWithTitle:title message:message buttonTitle:buttonTitle  isTwoButton:NO haveMidButton:YES middleButtonTitle:middleButtonTitle imageButton:imageButton isKnown:YES];
    alertView.midButtonClick = click;
    alertView.knownButtonClick = knownclick;
}

+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle{
    
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    
    [alertView configAlertViewPropertyWithTitle:title message:message buttonTitle:buttonTitle  isTwoButton:NO haveMidButton:NO middleButtonTitle:@"" imageButton:nil isKnown:NO];
}

+ (void)showTwoButtonAlertWithTitle:(NSString *)title message:(NSString *)message  actionButtonTitle:(NSString *)actionButtonTitle click:(clickHandle)click{
    
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.rightButtonClick = click;
    [alertView configAlertViewPropertyWithTitle:title message:message buttonTitle:actionButtonTitle  isTwoButton:YES haveMidButton:NO middleButtonTitle:@"" imageButton:nil isKnown:NO];
}
+ (void)showTwoActionAlertViewWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftClick:(clickHandle)leftClick rightClick:(clickHandle)rightClick{
    
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.leftButtonClick = leftClick;
    alertView.rightButtonClick = rightClick;
    [alertView configAlertViewPropertyWithTitle:title message:message  leftButtonTitle:leftButtonTitle rightButtonTitle:rightButtonTitle];
    
}
- (void)configAlertViewPropertyWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle isTwoButton:(BOOL)isTwoButton haveMidButton:(BOOL)haveMidButton middleButtonTitle:(NSString *)middleButtonTitle imageButton:(UIImage *)imageButton isKnown:(BOOL)isKnown{
    
    [self.screenShotView removeFromSuperview];
    [self.alertContentView removeFromSuperview];
    /**
     *  第一步添加屏幕毛玻璃截图
     */
    
    [self addScreenShot];
    /**
     *  第二步配置alertView界面
     */
    [self configAlertContentViewWithTitle:title Message:message ButtonTitle:buttonTitle  isTwoButton:isTwoButton haveMidButton:haveMidButton middleButtonTitle:middleButtonTitle imageButton:imageButton isKnown:isKnown];
    /**
     *  第三步将配置好的alertView添加到window上
     */
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertContentView];
    
}
- (void)configAlertViewPropertyWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle{
    [self.screenShotView removeFromSuperview];
    [self.alertContentView removeFromSuperview];
    [self addScreenShot];
    
    self.alertContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 210)];
    self.alertContentView.backgroundColor = [UIColor whiteColor];
    self.alertContentView.center = [UIApplication sharedApplication].keyWindow.center;
    CGFloat gap = 10;
    self.alertContentView.layer.cornerRadius = 5;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(gap, gap, self.alertContentView.bounds.size.width - 2*gap, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.text = title;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(gap, gap + 25, self.alertContentView.bounds.size.width - 2*gap, 0.5)];
    lineView.backgroundColor = [UIColor darkTextColor];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*gap, lineView.frame.origin.y + gap + 5, self.alertContentView.bounds.size.width-4*gap, 60)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor colorWithWhite:0.149 alpha:1.000];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.text = message;
    
    [self.alertContentView addSubview:titleLabel];
    [self.alertContentView addSubview:lineView];
    [self.alertContentView addSubview:messageLabel];
    UIButton *leftButton = [UIBounceButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(30, self.alertContentView.bounds.size.height - 70, (self.alertContentView.bounds.size.width-80)/2.0, 40);
    leftButton.layer.cornerRadius = 5;
    leftButton.layer.masksToBounds = YES;
    leftButton.backgroundColor = [UIColor whiteColor];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContentView addSubview:leftButton];
    
    UIButton *rightButton = [UIBounceButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(leftButton.frame.origin.x + leftButton.bounds.size.width + 20, self.alertContentView.bounds.size.height - 70, (self.alertContentView.bounds.size.width-80)/2.0, 40);
    rightButton.layer.cornerRadius = 5;
    rightButton.layer.masksToBounds = YES;
    rightButton.backgroundColor = [UIColor whiteColor];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#dbaae4"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContentView addSubview:rightButton];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1.05), @(1.1), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = 0.3;
    [self.alertContentView.layer addAnimation:animation forKey:@"bouce"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertContentView];
}
-(void)hideAlertView{
    CGFloat duration = 0.2;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertContentView.alpha = 0;
        self.screenShotView.alpha = 0;
        self.alertContentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.screenShotView removeFromSuperview];
        
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alertContentView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished) {
        [self.alertContentView removeFromSuperview];
    }];
}
-(void)configAlertContentViewWithTitle:(NSString *)title Message:(NSString *)message ButtonTitle:(NSString *)buttonTitle isTwoButton:(BOOL)isTwoButton haveMidButton:(BOOL)haveMidButton middleButtonTitle:(NSString *)middleButtonTitle imageButton:(UIImage *)imageButton isKnown:(BOOL)isKnown{
    
    self.alertContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 210)];
    self.alertContentView.backgroundColor = [UIColor whiteColor];
    self.alertContentView.center = [UIApplication sharedApplication].keyWindow.center;
    CGFloat gap = 10;
    self.alertContentView.layer.cornerRadius = 5;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(gap, gap, self.alertContentView.bounds.size.width - 2*gap, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.text = title;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(gap, gap + 25, self.alertContentView.bounds.size.width - 2*gap, 0.5)];
    lineView.backgroundColor = [UIColor darkTextColor];
    
    self.messageLabel= [[UILabel alloc]initWithFrame:CGRectMake(2*gap, lineView.frame.origin.y + gap + 5, self.alertContentView.bounds.size.width-4*gap, 60)];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor colorWithWhite:0.149 alpha:1.000];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.text = message;
    
    [self.alertContentView addSubview:titleLabel];
    [self.alertContentView addSubview:lineView];
    [self.alertContentView addSubview:self.messageLabel];
    
    if (haveMidButton) {
        self.messageLabel.frame =CGRectMake(2*gap-10, lineView.frame.origin.y + gap + 5-10, self.alertContentView.bounds.size.width-4*gap, 50);
        self.midButton = [[UIBounceButton alloc]initWithFrame:CGRectMake(2*gap, lineView.frame.origin.y + gap + 40, 0, 0)];
        [self.midButton setBackgroundColor:[UIColor clearColor]];
        self.midButton.userInteractionEnabled = YES;
        [self.midButton setTitle:middleButtonTitle forState:UIControlStateNormal];
        [self.midButton setImage:imageButton forState:UIControlStateNormal];
        [self.midButton setTitleColor:[UIColor colorWithHexString:@"#dbaae4"] forState:UIControlStateNormal];
        [self.midButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.midButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.midButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.midButton addTarget:self action:@selector(minButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.midButton sizeToFit];
        self.midButton.frame = CGRectMake((self.alertContentView.bounds.size.width-self.midButton.bounds.size.width)/2, lineView.frame.origin.y + gap + 5+40, self.midButton.bounds.size.width, 40);
        [self.alertContentView addSubview:self.midButton];
    }
    
    if (isTwoButton) {
        
        UIButton *leftButton = [UIBounceButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(30, self.alertContentView.bounds.size.height - 70, (self.alertContentView.bounds.size.width-80)/2.0, 40);
        leftButton.layer.cornerRadius = 5;
        leftButton.layer.masksToBounds = YES;
        leftButton.backgroundColor = [UIColor lightGrayColor];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
        [self.alertContentView addSubview:leftButton];
        
        UIButton *rightButton = [UIBounceButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(leftButton.frame.origin.x + leftButton.bounds.size.width + 20, self.alertContentView.bounds.size.height - 70, (self.alertContentView.bounds.size.width-80)/2.0, 40);
        rightButton.layer.cornerRadius = 5;
        rightButton.layer.masksToBounds = YES;
        rightButton.backgroundColor = [UIColor redColor];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightButton setTitle:buttonTitle forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.alertContentView addSubview:rightButton];
        
    }else{
        
        UIButton *leftButton = [UIBounceButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(60, self.alertContentView.bounds.size.height - 70, self.alertContentView.bounds.size.width-120, 40);
        leftButton.layer.cornerRadius = 5;
        leftButton.layer.masksToBounds = YES;
        leftButton.backgroundColor = [UIColor colorWithHexString:@"#dbaae4"];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftButton setTitle:buttonTitle forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (isKnown) {
            [leftButton addTarget:self action:@selector(knownButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [leftButton addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.alertContentView addSubview:leftButton];
        
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1.05), @(1.1), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = 0.3;
    [self.alertContentView.layer addAnimation:animation forKey:@"bouce"];
}

+(void)changeMessageTitle:(NSString *)changeStr{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.messageLabel.text = changeStr;
}
+(void)changeMidButtonType{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    if (alertView.midButton.userInteractionEnabled) {
        alertView.midButton.userInteractionEnabled = NO;
    }else{
        alertView.midButton.userInteractionEnabled = YES;
    }
}

-(void)minButtonAction{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.midButtonClick();
}

-(void)leftButtonAction{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.leftButtonClick();
    [self hideAlertView];
}

-(void)buttonAction{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.rightButtonClick();
    [self hideAlertView];
}

-(void)knownButtonAction{
    DJWYAlertView *alertView = [DJWYAlertView sharedInstance];
    alertView.knownButtonClick();
    [self hideAlertView];
}
- (void)addScreenShot{
    
    UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        originalImage = viewImage;
    } else {
        CGImageRef subImageRef = CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460));
        originalImage = [UIImage imageWithCGImage:subImageRef];
        CGImageRelease(subImageRef);
    }
    
    CGFloat blurRadius = 4;
    UIColor *tintColor = [UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:0.2];
    CGFloat saturationDeltaFactor = 1;
    UIImage *maskImage = nil;
    
    CGRect imageRect = { CGPointZero, originalImage.size };
    UIImage *effectImage = originalImage;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -originalImage.size.height);
        CGContextDrawImage(effectInContext, imageRect, originalImage.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1;
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -originalImage.size.height);
    
    CGContextDrawImage(outputContext, imageRect, originalImage.CGImage);
    
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.screenShotView = [[UIImageView alloc] initWithImage:outputImage];
    self.screenShotView.userInteractionEnabled = YES;
    [self.screenShotView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenShotViewTaped)]];
    [screenWindow addSubview:self.screenShotView];
    
    
}
-(void)screenShotViewTaped{
    NSLog(@"screenShotViewTaped");
    [self hideAlertView];
}


@end
