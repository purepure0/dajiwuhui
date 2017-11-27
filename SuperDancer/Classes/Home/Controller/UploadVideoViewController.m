//
//  UploadVideoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "UploadVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QiniuSDK.h>
#import "SelectTypeView.h"
#import "KLCPopup.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "EditVideoImageViewController.h"

@interface UploadVideoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, assign) BOOL hasVideoData;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) SelectTypeView *seletTypeView;

@property (weak, nonatomic) IBOutlet UITextField *videoTitleLabel;

@property (nonatomic, copy) NSString *resultPath;//视频本地路径
@property (nonatomic, copy) NSString *url;//视频七牛url
@property (nonatomic, copy) NSString *size;//视频长度
@property (nonatomic, copy) NSString *imgVal; //封面帧数
@property (nonatomic, copy) NSString *topid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *mp3;   //视频音乐ID
@property (nonatomic, copy) NSString *group; //标签
@property (nonatomic, strong) UIImage *videoImg;


@end

@implementation UploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频上传";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];;
    self.navigationItem.rightBarButtonItem = item;
    if (_soureType == UIImagePickerControllerSourceTypePhotoLibrary) {//选择
        [btn setTitle:@"选择视频" forState:UIControlStateNormal];
    }else {//录制
        [btn setTitle:@"录制视频" forState:UIControlStateNormal];
    }

    _videoData = [NSData data];
    _hasVideoData = NO;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
    [self seupPopupView];
}

- (void)btnClick:(UIButton *)btn {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void)seupPopupView {
    _seletTypeView = [[SelectTypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    @weakify(self);
    _seletTypeView.block = ^(NSString *topid, NSString *tid) {
        @strongify(self);
        NSLog(@"%@--%@", topid, tid);
        self.topid = topid;
        self.tid = tid;
        [self uploadVideoToQiNiu];
        [self.popup dismiss:YES];
    };
    _popup = [KLCPopup popupWithContentView:self.seletTypeView
                                   showType:KLCPopupShowTypeBounceInFromBottom
                                dismissType:KLCPopupDismissTypeBounceOutToBottom
                                   maskType:KLCPopupMaskTypeDimmed
                   dismissOnBackgroundTouch:YES
                      dismissOnContentTouch:NO];
}

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = _soureType;
        NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        _imagePicker.mediaTypes = [NSArray arrayWithObjects:availableMedia[1], nil];
        _imagePicker.videoMaximumDuration = 30.f;
        _imagePicker.delegate = self;
        _imagePicker.navigationBar.translucent = NO;
        
    }
    return _imagePicker;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"%@--%@", image, editingInfo);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@", info);
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    //NSLog(@"%@",compatiblePresets);
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession=[[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        NSDateFormatter *formater=[[NSDateFormatter alloc] init];//用时间给文件全名
        [formater setDateFormat:@"yyyyMMddHHmmss"];
//        NSString *mp4Path=[[NSUserDefaults standardUserDefaults] objectForKey:@"kMP4FilePath"];
        _resultPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingFormat:@"/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        exportSession.outputURL=[NSURL fileURLWithPath:_resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                    break;
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"resultPath = %@", _resultPath);
                    _hasVideoData = YES;
                    [self setVideoSize:_resultPath];
                    [self setVideoImgWithPath:_resultPath];
                    break;
                }
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    break;
            }
        }];
    }
}


- (void)setVideoSize:(NSString *)videoPath {
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    CMTime   time = [asset duration];
    NSInteger seconds = ceil(time.value/time.timescale);
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    _size  = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    NSLog(@"%@", _size);
//    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
//
//    return @{@"size" : @(fileSize),
//             @"duration" : @(seconds)};
}

- (void)setVideoImgWithPath:(NSString *)videoPath {
    self.imgVal = @"1";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [self frameImageFromVideoURL:[NSURL fileURLWithPath:videoPath]];
        NSLog(@"img");
        self.imgView.image = image;
    });
}


- (UIImage *)frameImageFromVideoURL:(NSURL *)videoURL {
    // result
    UIImage *image = nil;
    
    // AVAssetImageGenerator
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    // calculate the midpoint time of video
    Float64 duration = CMTimeGetSeconds([asset duration]);
    // 取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
    // 通常来说，600是一个常用的公共参数，苹果有说明:
    // 24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
    // Japan), and 25 fps for PAL (used for TV in Europe).
    // Using a timescale of 600, you can exactly represent any number of frames in these systems
    CMTime midpoint = CMTimeMakeWithSeconds(duration / 2.0, 600);
    
    // get the image from
    NSError *error = nil;
    CMTime actualTime;
    // Returns a CFRetained CGImageRef for an asset at or near the specified time.
    // So we should mannully release it
    CGImageRef centerFrameImage = [imageGenerator copyCGImageAtTime:midpoint
                                                         actualTime:&actualTime
                                                              error:&error];
    
    if (centerFrameImage != NULL) {
        image = [[UIImage alloc] initWithCGImage:centerFrameImage];
        // Release the CFRetained image
        CGImageRelease(centerFrameImage);
    }
    
    return image;
}

//截帧 编辑封面
- (IBAction)editVideoImg:(id)sender {
    if (_hasVideoData) {
        EditVideoImageViewController *ed = [[EditVideoImageViewController alloc] init];
        ed.videoURL = _resultPath;
        ed.tmpImage = _imgView.image;
        ed.selctedBlock = ^(NSInteger index, UIImage *image) {
            _imgVal = [NSString stringWithFormat:@"%ld", index];
            _imgView.image = image;
        };
        [self.navigationController pushViewController:ed animated:YES];
    }else {
        [MBProgressHUD showError:@"请先选择视频！" toView:self.view];
    }
}


- (IBAction)uploadBtnClick:(id)sender {
    if (!_hasVideoData) {
        [MBProgressHUD showError:@"未选择视频！" toView:self.view];
        return;
    }
    if (self.videoTitleLabel.text.length == 0) {
        [MBProgressHUD showError:@"未设置标题！" toView:self.view];
        return;
    }

    [_popup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    
}

//上传七牛
- (void)uploadVideoToQiNiu {
    NSData *videoData = [NSData dataWithContentsOfFile:_resultPath];
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,KQiniuToken) parameters:nil success:^(id responseObject) {
        NSString *token = responseObject[@"data"][@"res"][@"token"];
        PPLog(@"七牛token = %@",token);
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"video/mp4" progressHandler:^(NSString *key, float percent) {
            NSLog(@"percent:%f", percent);
        } params:nil checkCrc:YES cancellationSignal:nil];
        
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:videoData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            PPLog(@"Qiniu info = %@", info);
            PPLog(@"Qiniu resp = %@", resp);
            PPLog(@"Qiniu key = %@", key);
            if (info.ok) {
                NSString *url = NSStringFormat(@"%@%@", kQiniuURLHost, resp[@"key"]);
                [self uploadVideoInfoWithURL:url];
            }
            
        } option:opt];
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

- (void)uploadVideoInfoWithURL:(NSString *)url {
    NSDictionary *body = @{@"title": self.videoTitleLabel.text,
                           @"url": url,
                           @"topid": self.topid,
                           @"tid": self.tid,
                           @"size": self.size,
                           @"imgval": self.imgVal,
                           @"group": @"76"
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kUploadVide) parameters:body success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self hideLoading];
    }] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
