//
//  DownloadedCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/11.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

@interface DownloadedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel *fileInfo;

@end
