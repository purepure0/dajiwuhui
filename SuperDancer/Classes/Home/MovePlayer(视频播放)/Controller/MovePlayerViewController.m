//
//  MovePlayerViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/7.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MovePlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFDownloadManager.h"
#import "ZFCommonHelper.h"
#import "ZFPlayer.h"

#import "HomeCell.h"
#import "ContentCell.h"
#import "HandleCell.h"
#import "HeaderReusableView.h"
#import "CommentCell.h"
#import "CommentView.h"
#import "CommentModel.h"
#import "LikeModel.h"
#import "KeepModel.h"
#import "ReplyCommentModel.h"
#import "SaveBrowseRecord.h"
#import "PersonalCenterViewController.h"
#import <UShareUI/UShareUI.h>

#define kHomeCellIdentifier @"HomeCellIdentifier"
#define kContentCellIdentifier @"ContentCellIdentifier"
#define kHandleCellIdentifier @"HandleCellIdentifier"
#define kCommentCellIdentifier @"CommentCellIdentifier"
#define kHeaderReusableViewIdentifier @"HeaderReusableViewIdentifier"
#define kFooterReusableViewIdentifier @"FooterReusableViewIdentifier"
#define kCommentVideo @0
#define kReplyComment @1
@interface MovePlayerViewController () <ZFPlayerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *videoList;

//评论框
@property (nonatomic, strong)CommentView *commentView;
//回复框
@property (nonatomic, strong)CommentView *replyView;

@property (nonatomic, strong)HandleCell *handleCell;

@property (nonatomic, strong)LikeModel *likeModel;

@property (nonatomic, strong)KeepModel *keepModel;

@property (nonatomic, strong)PlayVideoModel *playVideoModel;


@property (nonatomic, strong)NSMutableArray *commentTypeList;
//存评论和回复的model
@property (nonatomic, strong)NSMutableArray *commentList;
//只存评论的model
@property (nonatomic, strong)NSMutableArray *onlyCommentList;

@property (nonatomic, strong)NSDictionary *videoInfo;

@end


@implementation MovePlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        self.playerView.playerPushedOrPresented = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.users.userId) {//登录之后才保存浏览记录
        [SaveBrowseRecord saveBrowseRecordWithUid:self.playVideoModel.vid];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
    self.collectionView.mj_footer = self.footer;
    
    self.fd_prefersNavigationBarHidden = YES;
//    self.videoURL = [NSURL URLWithString:self.model.url];
    
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
    
    // collection view cell
    [self.collectionView registerNib:NIB_NAMED(@"HomeCell") forCellWithReuseIdentifier:kHomeCellIdentifier];
    [self.collectionView registerNib:NIB_NAMED(@"ContentCell") forCellWithReuseIdentifier:kContentCellIdentifier];
    [self.collectionView registerNib:NIB_NAMED(@"HandleCell") forCellWithReuseIdentifier:kHandleCellIdentifier];
    [self.collectionView registerNib:NIB_NAMED(@"CommentCell") forCellWithReuseIdentifier:kCommentCellIdentifier];
    
    // 头视图
    [self.collectionView registerNib:NIB_NAMED(@"HeaderReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReusableViewIdentifier];
    // 脚视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReusableViewIdentifier];
    
    [self setupSendCommentView];
    [self setupReplyView];
    self.page = 1;
    [self initDataSource];
}

//评论框 一直显示
- (void)setupSendCommentView {
    _commentView = [[CommentView alloc] initCommentViewWithFrame:CGRectMake(0, 0, 0, 0) andViewType:ViewTypeComment];
    [self.view addSubview:_commentView];
    [_commentView.frontBtn addTarget:self action:@selector(startCommentVideo) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    _commentView.commitBlock = ^{
        @strongify(self);
        [self commitComment];
    };
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    __weak typeof(self) weakSelf = self;
    _commentView.updateHeightBlock = ^(CGFloat height) {
        [weakSelf.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    };
}

//回复框 回复时显示
- (void)setupReplyView {
    _replyView = [[CommentView alloc] initCommentViewWithFrame:CGRectMake(0, 0, 0, 0) andViewType:ViewTypeReply];
    [self.view addSubview:_replyView];
    @weakify(self);
    _replyView.replyBlock = ^(NSString *cid) {
        @strongify(self);
        [self commitReplytWithCid:cid];
    };
    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    __weak typeof(self) weakSelf = self;
    _replyView.updateHeightBlock = ^(CGFloat height) {
        [weakSelf.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    };
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return ZFPlayerShared.isStatusBarHidden;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerShare:(NSString *)url {
//    PPLog(@"分享 url = %@",url);
//    PPLog(@"//==%@",self.playVideoModel.img);
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];

}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.playVideoModel.title descr:self.playVideoModel.title thumImage:IMAGE_NAMED(@"Icon")];
    
    shareObject.webpageUrl = NSStringFormat(@"http://www.dajiwuhui.com/api/video/play_h5?vid=%@",self.playVideoModel.vid);
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [self toast:@"分享失败"];
        } else {
            [self toast:@"分享成功"];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            } else {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    [UIView animateWithDuration:0.3 animations:^{
        self.returnBtn.alpha = 0;
    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    [UIView animateWithDuration:0.3 animations:^{
        self.returnBtn.alpha = !fullscreen;
    }];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel = [[ZFPlayerModel alloc] init];
        _playerModel.videoURL = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        [_playerView playerControlView:nil playerModel:self.playerModel];
        _playerView.delegate = self;
        _playerView.hasDownload = NO;
        _playerView.hasShare = YES;
        self.playerView.hasPreviewView = YES;
    }
    return _playerView;
}


#pragma mark -

- (void)handleActionIndex:(NSInteger)index
{
    if (index == 1) {/** 下载*/
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *fileUrl = [self.videoURL absoluteString];
            NSString *fileName = [fileUrl lastPathComponent];
            
            NSString *fileTitle = self.playVideoModel.title;
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.playVideoModel.img]];
            UIImage *fileImg = [UIImage imageWithData:data];
            
            [[ZFDownloadManager sharedDownloadManager] downFileUrl:fileUrl fileId:self.vid filename:fileName fileTitle:fileTitle fileimage:fileImg];
            [ZFDownloadManager sharedDownloadManager].maxCount = 4;
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        });
    } else if (index == 2) {/** 收藏*/
        NSDictionary *body = @{@"vid": self.vid};
        [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kVideoCollect) parameters:body success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            self.keepModel.code = responseObject[@"code"];
            self.keepModel.message = responseObject[@"message"];
            [MBProgressHUD showSuccess:self.keepModel.message toView:self.view];
        } failure:^(NSError *error) {
            PPLog(@"%@", error.description);
        }];
    } else {/** 点赞*/
        NSDictionary *body = @{@"vid": self.vid};
        [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kVideoLike) parameters:body success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            self.likeModel.code = responseObject[@"code"];
            self.likeModel.message = responseObject[@"message"];
//          [MBProgressHUD showSuccess:self.likeModel.message toView:self.view];
            [self success:self.likeModel.message];
        } failure:^(NSError *error) {
            PPLog(@"%@", error.description);
        }];
    }
}

//TODO:网格视图
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger index = 0;
    switch (section)
    {
        case 0: index = 2; break;
        case 1: index = _videoList.count; break;
        case 2: index = _commentList.count; break;
    }
    return index;
}

- (BOOL)isExit {
    NSString *fileUrl = [self.videoURL absoluteString];
    NSString *fileName = [fileUrl lastPathComponent];

    NSString *tempfilePath = [TEMP_PATH(fileName) stringByAppendingString:@".plist"];
    PPLog(@"*****%@",tempfilePath);
    return [ZFCommonHelper isExistFile:FILE_PATH(fileName)] || [ZFCommonHelper isExistFile:tempfilePath];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ContentCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellIdentifier forIndexPath:indexPath];
            if (self.playVideoModel) {
                contentCell.titleLabel.text = self.playVideoModel.title;
                contentCell.typeLabel.text = self.playVideoModel.tname;
                contentCell.browseLabel.text = [NSString stringWithFormat:@"%@浏览", self.playVideoModel.num];
            }
            return contentCell;
        } else {
            if (!_handleCell) {
                _handleCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHandleCellIdentifier forIndexPath:indexPath];
                _handleCell.likeModel = self.likeModel;
                _handleCell.keepModel = self.keepModel;
                // 下载、收藏、点赞
                @weakify(self);
                _handleCell.handleBlock = ^(NSInteger index) {
                    @strongify(self);
                    [self handleActionIndex:index];
                };
                // 头像
                _handleCell.imgTapBlock = ^{
                    @strongify(self);
                    PersonalCenterViewController *p = [[PersonalCenterViewController alloc] init];
                    p.userId = NSStringFormat(@"%@",self.playVideoModel.uid);
                    [self.navigationController pushViewController:p animated:YES];
                };
            }
            
            _handleCell.nicknameLabel.text = self.playVideoModel.nick_name;
            [_handleCell.avatarImgView setImageWithURLString:self.playVideoModel.user_headimg placeholder:IMAGE_NAMED(@"myaccount")];
            [_handleCell updateDownloadStatus:[self isExit]];

//            PPLog(@"is file exit == %@",[self isExit] ? @"yes,has download":@"no,has not download");
    
            return _handleCell;
        }
    } else if (indexPath.section == 1) {
        HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
        NSLog(@"...%@", _videoList);
        VideoListModel *model = _videoList[indexPath.row];
        [cell setModel:model];
        return cell;
    } else {
        CommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommentCellIdentifier forIndexPath:indexPath];
        if ([_commentTypeList[indexPath.row] isEqual:kCommentVideo]) {
            CommentModel *commentModel = _commentList[indexPath.row];
            [cell setCommentModel:commentModel];
            @weakify(self);
            cell.replyBlock = ^(CommentModel *commentModel) {
                @strongify(self);
                [self startReplyCommentWith:commentModel];
            };
        }else {
            ReplyCommentModel *replyCommentModel = _commentList[indexPath.row];
            [cell setReplyCommentModel:replyCommentModel];
        }
        
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(kScreenWidth, 70);
        } else {
            return CGSizeMake(kScreenWidth, 65);
        }
    } else if (indexPath.section == 1) {
        return CGSizeMake((kScreenWidth-35)/2, kAutoWidth(140));
    } else {
        NSString *content = nil;
        CGFloat width = 0;
        if ([_commentTypeList[indexPath.row] isEqual:kCommentVideo]) {
            CommentModel *commentModel = _commentList[indexPath.row];
            content = commentModel.content;
            width = kScreenWidth - 97;
        }else {
            ReplyCommentModel *replyCommentModel = _commentList[indexPath.row];
            content = replyCommentModel.content;
            width = kScreenWidth - 162;
        }
        
        CGRect rect = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 97, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
        NSLog(@"%f", rect.size.height);
        return CGSizeMake(kScreenWidth, rect.size.height + 90);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 15, 15, 15);
    }
    return UIEdgeInsetsZero;
}

/** 添加头视图*/
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HeaderReusableView *header = (HeaderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderReusableViewIdentifier forIndexPath:indexPath];
        
        reusableView = header;
        
        header.moreBtn.hidden = YES;
        
        if (indexPath.section == 1) {
            header.titleLabel.text = @"猜你喜欢";
        } else if (indexPath.section == 2) {
            header.titleLabel.text = @"评论";
        }
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReusableViewIdentifier forIndexPath:indexPath];
        footer.backgroundColor = [UIColor colorWithHexString:@"FBFBFB"];
        
        reusableView = footer;
    }
    return reusableView;
}

/** 头视图的宽高*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGSizeZero : CGSizeMake(kScreenWidth, 55);
}

/** 脚视图的宽高*/
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return section == 0 || section == 2 ? CGSizeZero : CGSizeMake(kScreenWidth, 10);
}

/** 垂直最小间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return 15;
    }
    return 0;
}

/** 水平最小间距*/ 
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MovePlayerViewController *movePlayer = [[MovePlayerViewController alloc] init];
        VideoListModel *model = self.videoList[indexPath.row];
        movePlayer.vid = model.vid;
        movePlayer.videoURL = [NSURL URLWithString:model.url];
        [self.navigationController pushViewController:movePlayer animated:YES];
    }
}

- (IBAction)returnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 数据
- (void)initDataSource {
    _videoList = [NSMutableArray new];
    
    _onlyCommentList = [NSMutableArray new];
    _commentTypeList = [NSMutableArray new];
    _commentList = [NSMutableArray new];
    PPLog(@"&&&&&vid = %@ \n &&&&videoURL = %@",self.vid,self.videoURL);
    
    [self showLoading];
    NSDictionary *body = @{@"vid":self.vid,
                           @"page":[NSString stringWithFormat:@"%ld", self.page]
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kPlayer) parameters:body success:^(id responseObject) {
        NSLog(@"playing video responseObject = %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //视频信息
            NSDictionary *video = responseObject[@"data"][@"Video_player"][@"video"];
            self.playVideoModel = [[PlayVideoModel alloc] initWithDict:video];
//            PPLog(@"playVideoModel nick_name = %@",playVideoModel.nick_name);
            
            //猜你喜欢
            NSArray *videoIndex = responseObject[@"data"][@"Video_player"][@"about"];
            for (NSDictionary *dict in videoIndex) {
                VideoListModel *model = [[VideoListModel alloc] initWithDict:dict];
                [_videoList addObject:model];
            }
            //评论
            NSArray *comments = responseObject[@"data"][@"Video_player"][@"comment"];
            for (NSDictionary *dict in comments) {
                CommentModel *model = [[CommentModel alloc] initModelWithDict:dict];
                [_onlyCommentList addObject:model];
                NSLog(@"%@", model.replyModel.data);
            }
            [self handleCommentData:_onlyCommentList];
            NSLog(@"评论类型：%@", _commentTypeList);
            //点赞
            NSDictionary *likeDic = responseObject[@"data"][@"Video_player"][@"like"];
            self.likeModel.code = likeDic[@"code"];
            self.likeModel.message = likeDic[@"message"];
            //收藏
            NSDictionary *keepDic = responseObject[@"data"][@"Video_player"][@"keep"];
            self.keepModel.code = keepDic[@"code"];
            self.keepModel.message = keepDic[@"message"];
            
            [_collectionView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self hideLoading];
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        [self hideLoading];
    }];
}

- (void)loadMore:(MJRefreshAutoStateFooter *)footer {
    self.page ++;
    NSDictionary *body = @{@"vid":self.vid,
                           @"page":[NSString stringWithFormat:@"%ld", self.page]
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kPlayer) parameters:body success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *comments = responseObject[@"data"][@"Video_comment"];
            if (comments.count == 0) {
                [self.footer endRefreshing];
                [MBProgressHUD showSuccess:@"没有更多评论！" toView:self.view];
                return;
            }else {
                for (NSDictionary *dict in comments) {
                    CommentModel *model = [[CommentModel alloc] initModelWithDict:dict];
                    [_onlyCommentList addObject:model];
                    NSLog(@"%@", model.replyModel.data);
                }
                [self handleCommentData:_onlyCommentList];
            }
            
            [self.footer endRefreshing];
            [_collectionView reloadData];
        }else {
            [self.footer endRefreshing];
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    
    } failure:^(NSError *error) {
        [self.footer endRefreshing];
        PPLog(@"%@", error.description);
    }];
}



- (LikeModel *)likeModel {
    if (_likeModel == nil) {
        _likeModel = [[LikeModel alloc] init];
    }
    return _likeModel;
}

- (KeepModel *)keepModel {
    if (_keepModel == nil) {
        _keepModel = [[KeepModel alloc] init];
    }
    return _keepModel;
}


#pragma mark -- 评论/回复
//评论
- (void)startCommentVideo {
    [_commentView commentWithVid:self.vid];
}


//回复
- (void)startReplyCommentWith:(CommentModel *)commentModel {
    NSLog(@"cid==%@", commentModel.cid);
    [_replyView replyWithCId:commentModel.cid andAuthor:commentModel.nick_name];
}

#pragma mark -- 上传评论
- (void)commitComment {
    NSLog(@"评论");
    if (_commentView.commentTextView.text.length == 0) {
        [MBProgressHUD showError:@"请填入内容" toView:self.view];
        return;
    }
    [self showLoading];
    NSDictionary *body = @{@"vid": self.vid,
                           @"content": _commentView.commentTextView.text
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kAddComment) parameters:body success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        
        
        NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
        if ([code isEqualToString:@"0"]) {
            //回复评论框的状态
            _commentView.commentTextView.text = @"";
            [_commentView.commentTextView resignFirstResponder];
            [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
            [_commentView.placeholderLabel setHidden:NO];
            //处理返回的数据，页码重置=1
            NSArray *comments = responseObject[@"data"][@"Video_player"][@"comment"];
            [_onlyCommentList removeAllObjects];
            self.page = 1;
            for (NSDictionary *dict in comments) {
                CommentModel *model = [[CommentModel alloc] initModelWithDict:dict];
                [_onlyCommentList addObject:model];
                NSLog(@"%@", model.replyModel.data);
            }
            [self handleCommentData:_onlyCommentList];
            
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        [self hideLoading];
    }];
    
}
#pragma mark -- 上传回复
- (void)commitReplytWithCid:(NSString *)cID {
    NSLog(@"回复：%@", cID);
    if (_replyView.commentTextView.text.length == 0) {
        [MBProgressHUD showError:@"请填入内容" toView:self.view];
        return;
    }
    [self showLoading];
    NSDictionary *body = @{@"cid": cID,
                           @"content": _replyView.commentTextView.text
                           };
    NSLog(@"%@", body);
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kCommentReply) parameters:body success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
        if ([code isEqualToString:@"0"]) {
            //恢复回复框的状态
            _replyView.commentTextView.text = @"";
            [_replyView.commentTextView resignFirstResponder];
            [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
            [_replyView.placeholderLabel setHidden:NO];
            //处理数据
            
            NSDictionary *data = responseObject[@"data"][@"Video_player"][@"comment"][0];
            CommentModel *model = [[CommentModel alloc] initModelWithDict:data];
            for (int i = 0; i < _onlyCommentList.count; i++) {
                CommentModel *oldModel = _onlyCommentList[i];
                if ([oldModel.cid isEqual:model.cid]) {
                    [_onlyCommentList removeObject:oldModel];
                    [_onlyCommentList insertObject:model atIndex:i];
                    [self handleCommentData:_onlyCommentList];
                }
            }
            
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
        [self hideLoading];
    }];
}


//处理评论数据
- (void)handleCommentData:(NSArray *)data {
    if (!_commentList) {
        _commentList = [NSMutableArray new];
        _commentTypeList = [NSMutableArray new];
    }else {
        [_commentList removeAllObjects];
        [_commentTypeList removeAllObjects];
    }
    
    for (CommentModel *commentModel in data) {
        [_commentList addObject:commentModel];
        [_commentTypeList addObject:kCommentVideo];
        for (NSDictionary *dict in commentModel.replyModel.data) {
            ReplyCommentModel *model = [[ReplyCommentModel alloc] initReplyCommentModelWithDict:dict];
            [_commentTypeList addObject:kReplyComment];
            [_commentList addObject:model];
        }
    }
    NSLog(@"评论类型：%@", _commentTypeList);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
