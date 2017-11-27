//
//  HistoryModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject
/*
 "log_id": 1338245,
 "vid": 570,
 "title": "军馨舞蹈学校  《飞呀飞》",
 "start_time": "2017-10-28 17:54:34",
 "url": "http:\/\/uploads.dajiwuhui.com\/o_1bpj1aaujfa21dc73dv1ama6ee9.mp4",
 "imgval": 125,
 "img": "http:\/\/uploads.dajiwuhui.com\/o_1bpj1aaujfa21dc73dv1ama6ee9.mp4?vframe\/jpg\/offset\/125",
 "user_headimg": "http:\/\/uploads.dajiwuhui.com\/Fk5HG0jSrHRJ_rR23wu_-M9wbHlr",
 "tname": "爵士舞"
 */
@property (nonatomic, copy)NSString *vid;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *imgval;
@property (nonatomic, copy)NSString *v_long;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *tname;
@property (nonatomic, copy)NSString *log_id;
@property (nonatomic, copy)NSString *dateMark;
@property (nonatomic, copy)NSString *user_headimg;

- (instancetype)initBrowseVideoModelWithDict:(NSDictionary *)dict;


@end


