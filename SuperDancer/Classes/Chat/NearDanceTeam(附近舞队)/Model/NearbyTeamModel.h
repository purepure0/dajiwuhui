//
//  NearbyTeamModel.h
//  SuperDancer
//
//  Created by yu on 2017/12/30.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyTeamModel : NSObject

@property (nonatomic, copy) NSString *tid;

@property (nonatomic, copy) NSString *tname;

@property (nonatomic, copy) NSString *owner;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *distance;

@end

@interface NearbyDancerModel : NSObject

@property (nonatomic, copy) NSString *accid;

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *sign;


@end
