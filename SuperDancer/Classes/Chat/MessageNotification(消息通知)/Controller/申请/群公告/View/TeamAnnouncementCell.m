//
//  TeamAnnouncementCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/31.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamAnnouncementCell.h"

@implementation TeamAnnouncementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 10)
    .heightIs(21);
    
    self.InfoLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, 10)
    .rightEqualToView(self.titleLabel)
    .heightRatioToView(self.titleLabel, 1);
    
    self.lineView.sd_layout
    .leftEqualToView(self.InfoLabel)
    .rightEqualToView(self.InfoLabel)
    .topSpaceToView(self.InfoLabel, 10)
    .heightIs(0.5);
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.lineView)
    .rightEqualToView(self.lineView)
    .topSpaceToView(self.lineView, 10)
    .autoHeightRatio(0);

    [self setupAutoHeightWithBottomView:self.contentLabel bottomMargin:10];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    self.titleLabel.text = data[@"title"];
    self.contentLabel.text = data[@"content"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] integerValue]];
    
    self.InfoLabel.text = NSStringFormat(@"发布人：%@  发布日期：%@",data[@"creator"],[dateFormatter stringFromDate:date]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
