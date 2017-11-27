//
//  SDHTTPRequest.h
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDHTTPRequest : NSObject

/**
 请求成功的block
 
 @param response 响应体数据
 */
typedef void(^SDRequestSuccess)(id response);

/**
 请求失败的block
 
 @param error 扩展信息
 */
typedef void(^SDRequestFailure)(NSError *error);

/**
 上传进度的block
 
 @param progress 上传进度
 */
typedef void (^SDHttpProgress)(CGFloat progress);

#pragma mark - 请求公共的方法 -

+ (NSURLSessionTask *)postRequestWithURL:(NSString *)URL
                              parameters:(id)parameter
                                 success:(SDRequestSuccess)success
                                 failure:(SDRequestFailure)failure;

+ (NSURLSessionTask *)getRequestWithURL:(NSString *)URL
                             parameters:(id)parameter
                                success:(SDRequestSuccess)success
                                failure:(SDRequestFailure)failure;

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(SDHttpProgress)progresses
                                  success:(SDRequestSuccess)success
                                  failure:(SDRequestFailure)failure;

@end
