//
//  GroupNoticeCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "GroupNoticeCell.h"
#import "PhotosContainerView.h"

@implementation GroupNoticeCell
{
    PhotosContainerView *_photosContainer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    [self.contentView addSubview:photosContainer];
    
    // 标题
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 10)
    .widthRatioToView(self.contentView, 0.5)
    .heightIs(25);
    
    // 发布时间
    self.timeLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, 5)
    .widthRatioToView(self.titleLabel, 1)
    .heightIs(20);
    
    // 已读数
    self.readNumLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.timeLabel)
    .widthIs(100)
    .heightRatioToView(self.timeLabel, 1);
    
    // 内容
    self.contentLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.timeLabel, 10)
    .autoHeightRatio(0);
    // 限制最多显示2行文字
    [self.contentLabel setMaxNumberOfLinesToShow:2];
    
    // 图片集
    _photosContainer.sd_layout
    .leftEqualToView(self.contentLabel)
    .rightEqualToView(self.contentLabel)
    .topSpaceToView(self.contentLabel, 10);
    
}

- (void)setModel:(GroupNoticeModel *)model
{
    _model = model;
    
    self.titleLabel.text = @"舞队公告1";
    self.timeLabel.text = @"发布时间：2017-10-10";
    self.readNumLabel.text = @"2人已读";
    self.contentLabel.text = model.content;
    
    UIView *bottomView = _contentLabel;
    
    _photosContainer.photoNamesArray = model.imageArray;
    if (model.imageArray.count > 0) {
        _photosContainer.hidden = NO;
        bottomView = _photosContainer;
    } else {
        _photosContainer.hidden = YES;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
