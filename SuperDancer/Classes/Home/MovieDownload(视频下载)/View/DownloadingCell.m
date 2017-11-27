//
//  DownloadingCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/11.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DownloadingCell.h"

@implementation DownloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [self.contentView addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(0.5);
}

- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.imgView.image = _fileInfo.fileimage;
    self.titleLabel.text = fileInfo.fileTitle;

    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];

    self.progressLabel.text = NSStringFormat(@"已缓存%.2f%%",progress*100);
    self.progressLabel2.text = NSStringFormat(@"%@/%@",currentSize,totalSize);
    self.progress.progress = progress;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
