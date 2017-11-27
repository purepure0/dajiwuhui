//
//  VideoListModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListModel : NSObject
    
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *imgval;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *tname;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *vid;
@property (nonatomic, copy)NSString *user_headimg;
//舞曲相关视频
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *tid;
@property (nonatomic, copy)NSString *nick_name;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface PlayVideoModel : NSObject

@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *user_headimg;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *user_headimg;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *signature;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

