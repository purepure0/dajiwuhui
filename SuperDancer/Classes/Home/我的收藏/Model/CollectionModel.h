//
//  CollectionModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject
/*
 "vid": 242,
 "title": "终兴镇光明集村文艺队《中国梦》",
 "num": 1543,
 "url": "http:\/\/uploads.dajiwuhui.com\/o_1bpavvs6p1t5ghtpfu5v2aqb99.mp4",
 "imgval": 46,
 "img": "http:\/\/uploads.dajiwuhui.com\/o_1bpavvs6p1t5ghtpfu5v2aqb99.mp4?vframe\/jpg\/offset\/46",
 "tname": "健身操"
 */
@property (nonatomic, copy)NSString *vid;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *imgval;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *tname;

- (instancetype)initCollectionModelWithDict:(NSDictionary *)dict;
@end
