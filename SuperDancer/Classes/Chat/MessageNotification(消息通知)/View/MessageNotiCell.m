//
//  MessageNotiCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MessageNotiCell.h"

@implementation MessageNotiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.unreadCountLabel.layer.masksToBounds = YES;
    self.unreadCountLabel.layer.cornerRadius  = self.unreadCountLabel.height / 2;
    
}

- (void)updateCellWithData:(NSDictionary *)dic {
    self.imgView.image = [UIImage imageNamed:dic[@"img"]];
    self.mTitleLabel.text = dic[@"title"];
    self.lastMessageLabel.text = dic[@"lastMessage"];
    self.dateLabel.text = dic[@"date"];
    self.unreadCountLabel.text = dic[@"unreadCount"];
    
    if ([dic[@"unreadCount"] integerValue] == 0) {
        [self.unreadCountLabel setHidden:YES];
    }else {
        [self.unreadCountLabel setHidden:NO];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
