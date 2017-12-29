//
//  MemberManageCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MemberManageCell.h"

@implementation MemberManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [self.contentView addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 0.5)
    .heightIs(0.5);

    self.deleteBtn.sd_layout
    .leftSpaceToView(self.contentView, -30)
    .centerYEqualToView(self.contentView)
    .widthIs(30)
    .heightEqualToWidth();
    
    self.iconImg.sd_layout
    .leftSpaceToView(self.deleteBtn, 15)
    .centerYEqualToView(self.deleteBtn)
    .heightIs(60)
    .widthEqualToHeight();
    
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.nameLabel.sd_layout
    .leftSpaceToView(self.iconImg, 10)
    .topEqualToView(self.iconImg)
    .heightIs(30);
    
    self.leaderLabel.sd_layout
    .leftSpaceToView(self.nameLabel, 10)
    .centerYEqualToView(self.nameLabel)
    .widthIs(40)
    .heightIs(20);
    
    self.introduceLabel.sd_layout
    .bottomEqualToView(self.iconImg)
    .leftEqualToView(self.nameLabel)
    .widthIs(300)
    .heightRatioToView(self.nameLabel, 1);
    
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = 30;
    
}

- (void)layoutSubviews:(BOOL)isEdit
{
    if (isEdit) {
        [self.deleteBtn updateLayout];
        [self updateLayout];
        self.deleteBtn.sd_layout
        .leftSpaceToView(self.contentView, 15);
    } else {
        [self.deleteBtn updateLayout];
        self.deleteBtn.sd_layout
        .leftSpaceToView(self.contentView, -30);
    }
}

- (void)layoutSubviews:(BOOL)isEdit indexPath:(NSIndexPath *)indexPath
{
    if (isEdit) {
        [self.deleteBtn updateLayout];
        [self updateLayout];
        self.deleteBtn.sd_layout
        .leftSpaceToView(self.contentView, 15);
    } else {
        [self.deleteBtn updateLayout];
        self.deleteBtn.sd_layout
        .leftSpaceToView(self.contentView, -30);
    }
    self.deleteBtn.tag = indexPath.row;
    self.deleteBtn.hidden = !indexPath.row ? YES:NO;
    self.leaderLabel.hidden = !indexPath.row ? NO:YES;
}

- (IBAction)deleteAction:(UIButton *)btn {
    if (self.deleteBlock) {
        self.deleteBlock(btn.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
