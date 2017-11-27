//
//  DownloadedCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/11.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DownloadedCell.h"

@implementation DownloadedCell

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
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.titleLabel.text = fileInfo.fileTitle;
    self.sizeLabel.text = totalSize;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
