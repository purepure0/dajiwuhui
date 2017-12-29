//
//  SDInterfacedConst.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDInterfacedConst.h"

#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"http://www.dajiwuhui.com/api";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"";
#endif


#pragma mark -- 公共参数

NSString *const kUserID = @"Userid";
NSString *const kUserToken = @"Usertoken";


/** 手机验证码*/
NSString *const kVerifyCode = @"/login/index";
/** 帐号登录*/
NSString *const kLogin = @"/login/check_code";
/** 微信登录*/
NSString *const kWchatLogin = @"/login/wchatLogin";
/** 推荐视频*/
NSString *const kIndex = @"/video/index";
/** 广场舞视频*/
NSString *const kAdult = @"/video/adult";
/** 儿童舞视频*/
NSString *const kChildren = @"/video/chiidren";
/** 同城视频*/
NSString *const kLocal = @"/video/local";
/** 视频播放页*/
NSString *const kPlayer = @"/video/player";

/** 视频浏览记录*/
NSString *const kBrowseVideoLog = @"/member/play_log";

/** 插入视频浏览记录*/
NSString *const kPlayLog = @"/video/play_log";

/** 视频点赞*/
NSString *const kVideoLike = @"/video/videoLike";

/** 视频收藏*/
NSString *const kVideoCollect = @"/video/video_collect";

/** 视频投票*/
NSString *const kVideoVote = @"/video/video_vote";

/** 视频评论发表*/
NSString *const kAddComment = @"/video/addComment";

/** 回复评论*/
NSString *const kCommentReply = @"/video/comment_reply";

/** 个人中心*/
NSString *const kPersonalCenter = @"/member/video";

/** 舞者列表*/
NSString *const kDance = @"/index/dance";

/** 视频类别分类*/
NSString *const kVideoType = @"/video/videoType";

/** 绑定手机号-获取验证码*/
NSString *const kGetCode = @"/member/mobile";

/** 绑定手机号-验证验证码*/
NSString *const kCheckCode = @"/member/checkcode";

/** 获取用户个人资料*/
NSString *const kGetUserInfo = @"/member/user";

/** 获取我的收藏*/
NSString *const kMyCollection = @"/member/collect";

/** 关注/取消关注用户*/
NSString *const kAttention = @"/member/attention";

/** 舞曲*/
NSString *const kMusic = @"/video/music";

/** 舞曲相关视频*/
NSString *const kMusicSelectVideo = @"/video/music_select_video";


/** 获取七牛token*/
NSString *const KQiniuToken = @"/syscomment/niuToken";

/** 所有市级(ABC排序)*/
NSString *const kAllCityabc = @"/syscomment/allCityabc";

/** 获取区县数据*/
NSString *const kDistrict = @"/syscomment/district";

/** 上传个人信息*/
NSString *const kUserUpdata = @"/member/userUpdata";

/** 七牛URL前缀*/
NSString *const kQiniuURLHost = @"http://uploads.dajiwuhui.com/";

/** 消息中心-评论*/
NSString *const kMyVideoComment = @"/member/MyVideoComment";

/** 消息中心-粉丝（关注）*/
NSString *const kMyFans = @"/member/MyFans";

/** 意见反馈 */
NSString *const kFeedback = @"/member/feedback";

/** 视频上传 */
NSString *const kUploadVide = @"/video/video_upload";

/** 我关注的舞者 */
NSString *const kMyLike = @"/member/MyLike";


/** 加好友-通过手机号搜索其他用户 */
NSString *const kGetUserInfoByTel = @"/im/tel";


/** 加好友-通过ID获取用户信息 */
NSString *const kGetUserInfoByUserId = @"/im/user_info";

/** 舞队-设置舞队位置 */
NSString *const kUpdateTeamLocality = @"/im/group_custom";

/** 舞队-附近的舞队*/
NSString *const kNearbyTeam = @"/im/nearby_team";


