//
//  GroupNoticeModel.h
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupNoticeModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *readNum;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray *imageArray;

@end
