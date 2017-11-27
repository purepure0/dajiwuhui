//
//  MusicModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, copy)NSString *mid;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *mp3;
@property (nonatomic, copy)NSString *type;

- (instancetype)initMusicModelWithDict:(NSDictionary *)dict;
@end
