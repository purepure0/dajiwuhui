//
//  TeamListForChatTableViewCell.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/11/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamListForChatTableViewCell.h"

@implementation TeamListForChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)updateCellWithData:(NSDictionary *)infoData{
    
    __weak typeof(self) weakSelf = self;
    //网络请求图片完成后设置圆角，用画的，执行效率高，也可用layer设置
//    [self.imageView setImageWithURL:[[NSURL alloc]initWithString:@""] placeholder:@"" options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        if(stage == YYWebImageStageFinished){
//            [weakSelf.imageView.image circleImage];
//        }
//
//    }];
    self.imageView.image = [[UIImage imageNamed:@"pic1"] circleImage];
    self.textLabel.text = @"舞队名称1";
    self.detailTextLabel.text = @"所在地区：山东省菏泽市";
    self.detailTextLabel.textColor = kTextGrayColor;
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kLineColor;
    [self sd_addSubviews:@[lineView]];
    lineView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1)
    .bottomSpaceToView(self, 0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
