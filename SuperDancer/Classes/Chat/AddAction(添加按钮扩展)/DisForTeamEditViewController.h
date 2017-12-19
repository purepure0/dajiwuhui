//
//  DisForTeamEditViewController.h
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^EditFinishedBlock) (NSString *teamIntro);
@interface DisForTeamEditViewController : BaseViewController

@property (nonatomic, copy)NSString *teamIntro;

@property (nonatomic, copy)EditFinishedBlock editFinised;

@end
