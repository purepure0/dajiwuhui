//
//  SDInterfacedConst.h
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDInterfacedConst : NSObject

/*
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 */

#define DevelopSever 0
#define TestSever    1
#define ProductSever 0

/** 接口前缀-开发服务器*/
UIKIT_EXTERN NSString *const kApiPrefix;


#pragma mark -- 公共参数

UIKIT_EXTERN NSString *const kUserID;
UIKIT_EXTERN NSString *const kUserToken;


#pragma mark - 详细接口地址 -

/** 手机验证码*/
UIKIT_EXTERN NSString *const kVerifyCode;
/** 帐号登录*/
UIKIT_EXTERN NSString *const kLogin;
/** 微信登录*/
UIKIT_EXTERN NSString *const kWchatLogin;
/** 推荐视频*/
UIKIT_EXTERN NSString *const kIndex;
/** 广场舞视频*/
UIKIT_EXTERN NSString *const kAdult;
/** 儿童舞视频*/
UIKIT_EXTERN NSString *const kChildren;
/** 同城视频*/
UIKIT_EXTERN NSString *const kLocal;
/** 视频播放页*/
UIKIT_EXTERN NSString *const kPlayer;

/** 视频浏览记录*/
UIKIT_EXTERN NSString *const kBrowseVideoLog;

/** 插入视频浏览记录*/
UIKIT_EXTERN NSString *const kPlayLog;

/** 视频点赞*/
UIKIT_EXTERN NSString *const kVideoLike;

/** 视频收藏*/
UIKIT_EXTERN NSString *const kVideoCollect;

/** 视频投票*/
UIKIT_EXTERN NSString *const kVideoVote;

/** 视频评论发表*/
UIKIT_EXTERN NSString *const kAddComment;

/** 回复评论*/
UIKIT_EXTERN NSString *const kCommentReply;

/** 个人中心*/
UIKIT_EXTERN NSString *const kPersonalCenter;

/** 舞者列表*/
UIKIT_EXTERN NSString *const kDance;

/** 视频类别分类*/
UIKIT_EXTERN NSString *const kVideoType;

/** 绑定手机号-获取验证码*/
UIKIT_EXTERN NSString *const kGetCode;

/** 绑定手机号-验证验证码*/
UIKIT_EXTERN NSString *const kCheckCode;

/** 获取用户个人资料*/
UIKIT_EXTERN NSString *const kGetUserInfo;

/** 获取我的收藏*/
UIKIT_EXTERN NSString *const kMyCollection;

/** 关注/取消关注用户*/
UIKIT_EXTERN NSString *const kAttention;

/** 舞曲*/
UIKIT_EXTERN NSString *const kMusic;

/** 舞曲相关视频*/
UIKIT_EXTERN NSString *const KMusicSelectVideo;

/** 获取七牛token*/
UIKIT_EXTERN NSString *const KQiniuToken;

UIKIT_EXTERN NSString *const kMusicSelectVideo;

/** 所有市级(ABC排序)*/
UIKIT_EXTERN NSString *const kAllCityabc;

/** 获取区县数据*/
UIKIT_EXTERN NSString *const kDistrict;

/** 上传个人信息*/
UIKIT_EXTERN NSString *const kUserUpdata;

/** 七牛URL前缀*/
UIKIT_EXTERN NSString *const kQiniuURLHost;

/** 消息中心-评论*/
UIKIT_EXTERN NSString *const kMyVideoComment;

/** 消息中心-粉丝（关注）*/
UIKIT_EXTERN NSString *const kMyFans;

/** 意见反馈 */
UIKIT_EXTERN NSString *const kFeedback;

/** 视频上传 */
UIKIT_EXTERN NSString *const kUploadVide;

/** 我关注的舞者 */
UIKIT_EXTERN NSString *const kMyLike;


@end



