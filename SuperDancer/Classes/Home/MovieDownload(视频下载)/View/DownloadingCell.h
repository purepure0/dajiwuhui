//
//  DownloadingCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/11.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

@interface DownloadingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel2;

/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest *request;

@end
