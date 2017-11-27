//
//  EditVideoImageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "EditVideoImageViewController.h"
#import <AVKit/AVKit.h>
#import "VideoImageCell.h"
#define kVideoImageCellidentifier @"VideoImageCellIdentifier"

@interface EditVideoImageViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *imgs;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign) CGFloat imageWidth;

@property (nonatomic, assign) NSInteger index;
@end

@implementation EditVideoImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑封面";
    _index = 0;
    _imageView.image = _tmpImage;
    _imgs = [NSMutableArray new];
    _timeLabel.text = @"00:01";
    [self.collectionView registerNib:NIB_NAMED(@"VideoImageCell") forCellWithReuseIdentifier:kVideoImageCellidentifier];
    self.collectionView.bounces = NO;
    [self splitVideo:[NSURL fileURLWithPath:_videoURL] fps:1 completedBlock:^{
        NSLog(@"over");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if (20 * _imgs.count < kScreenWidth) {
                _imageWidth = kScreenWidth / _imgs.count;
                _leftSpace.constant = _imageWidth - 6;
            }else {
                _imageWidth = 20;
                _leftSpace.constant = _imageWidth - 6;
            }
            [self.collectionView reloadData];
        });
    }];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"选取" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)selectAction:(UIButton *)btn {
    if (self.selctedBlock) {
        self.selctedBlock(_index + 1, _imageView.image);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)splitVideo:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)(void))completedBlock {
    if (!fileUrl) {
        return;
    }
    [self showLoading];
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    NSLog(@"------- start");
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSInteger timesCount = [times count];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        printf("current-----: %lld\n", requestedTime.value);
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                //                NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%lld.png",requestedTime.value]];
                NSData *imgData = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
                //                [imgData writeToFile:filePath atomically:YES];
                UIImage *image = [UIImage imageWithData:imgData];
                [_imgs addObject:image];
                if (requestedTime.value == timesCount) {
                    NSLog(@"completed");
                    if (completedBlock) {
                        completedBlock();
                    }
                }
            }
                break;
        }
    }];
}

#pragma mark -- delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoImageCellidentifier forIndexPath:indexPath];
    cell.imgView.image = _imgs[indexPath.row];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(_imageWidth, 53);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(_imageWidth, 53);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth - _imageWidth, 53);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger tmpIndex = scrollView.contentOffset.x / _imageWidth;
    if (_index != tmpIndex) {
        NSLog(@"%ld", _index);
        _index = tmpIndex;
        [self updateImageView];
    }
}

- (void)updateImageView {
    if (_index < 0) {
        _index = 0;
    }else if (_index > _imgs.count - 1) {
        _index = _imgs.count - 1;
    }
    _imageView.image = _imgs[_index];
    [self makeTime:_index + 1];
}

- (void)makeTime:(NSInteger)seconds {
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
//    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@", str_minute, str_second];
    
    _timeLabel.text = format_time;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
