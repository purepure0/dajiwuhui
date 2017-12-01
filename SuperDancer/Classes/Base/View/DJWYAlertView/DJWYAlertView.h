//
//  DJWYAlertView.h
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clickHandle)(void);

@interface DJWYAlertView : NSObject
@property(nonatomic,strong)UILabel *messageLabel;

+(void)showOneButtonWithTitleWithMidButton:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle middleButtonTitle:(NSString *)middleButtonTitle imageButton:(UIImage *)imageButton  click:(clickHandle)click knownclick:(clickHandle)knownclick ;

+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle;

+ (void)showTwoButtonAlertWithTitle:(NSString *)title message:(NSString *)message  actionButtonTitle:(NSString *)actionButtonTitle click:(clickHandle)click;

+ (void)showTwoActionAlertViewWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftClick:(clickHandle)leftClick rightClick:(clickHandle)rightClick;
+(void)changeMessageTitle:(NSString *)changeStr;
+(void)changeMidButtonType;

@end
