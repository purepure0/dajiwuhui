//
//  SDHTTPRequest.m
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDHTTPRequest.h"

#import "SDInterfacedConst.h"
#import "PPNetworkHelper.h"

@implementation SDHTTPRequest

/*
 配置好PPNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用PPNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 */

#pragma mark - 请求的公共方法

// TODO:POST请求
+ (NSURLSessionTask *)postRequestWithURL:(NSString *)URL parameters:(id)parameter success:(SDRequestSuccess)success failure:(SDRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    //    [PPNetworkHelper setValue:@"9" forHTTPHeaderField:@"fromType"];
    [PPNetworkHelper closeLog];
    //    [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
    // 发起请求
    return [PPNetworkHelper POST:URL parameters:parameter success:^(id responseObject) {
        
        // 在这里可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        //        [MBProgressHUD hideHUD];
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        
        //        [MBProgressHUD hideHUD];
        // 同上
        failure(error);
    }];
}

// TODO:GET请求
+ (NSURLSessionTask *)getRequestWithURL:(NSString *)URL parameters:(id)parameter success:(SDRequestSuccess)success failure:(SDRequestFailure)failure
{
    [PPNetworkHelper closeLog];
    return [PPNetworkHelper GET:URL parameters:parameter success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}


// TODO:POST请求(图片上传)
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(SDHttpProgress)progresses success:(SDRequestSuccess)success failure:(SDRequestFailure)failure
{
    [PPNetworkHelper closeLog];
    return [PPNetworkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:nil imageScale:imageScale imageType:imageType progress:^(NSProgress *progress) {
        
        CGFloat value = 100.0 * progress.completedUnitCount/progress.totalUnitCount;
        
        progresses(value);
        
    } success:^(id responseObject) {
        
        success (responseObject);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

@end
