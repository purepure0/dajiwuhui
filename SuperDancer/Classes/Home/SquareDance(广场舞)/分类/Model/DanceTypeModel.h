//
//  DanceTypeModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DanceTypeModel : NSObject

@property (nonatomic, copy)NSString *tid;
@property (nonatomic, copy)NSString *tname;
@property (nonatomic, copy)NSString *background;

- (instancetype)initDanceTypeModelWithDict:(NSDictionary *)dict;
@end
