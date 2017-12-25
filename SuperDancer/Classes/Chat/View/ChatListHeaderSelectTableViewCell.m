//
//  ChatListHeaderSelectTableViewCell.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/11/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ChatListHeaderSelectTableViewCell.h"

@interface ChatListHeaderSelectTableViewCell()

@end

@implementation ChatListHeaderSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

-(void)updateCellWithData:(NSDictionary *)infoData{
    
    if(infoData[@"states"]&&[infoData[@"states"] isEqualToString:@"0"]){
        self.imageView.image = [UIImage imageNamed:@"wd_list_icomessage"];
        if ([infoData[@"numOfMews"] isEqualToString:@"0"]) {
            self.textLabel.text = @"消息通知";
        }else {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",@"消息通知",infoData[@"numOfNews"]]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
            [str addAttribute:NSForegroundColorAttributeName value:kTextGrayColor range:NSMakeRange(4,str.length-4)];
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4,str.length-4)];
            
            self.textLabel.attributedText = str;
        }
        
    }else if(infoData[@"states"]&&[infoData[@"states"] isEqualToString:@"1"]){
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = kLineColor;
        [self sd_addSubviews:@[lineView]];
        lineView.sd_layout
        .leftSpaceToView(self, 30)
        .rightSpaceToView(self, 30)
        .heightIs(1)
        .topSpaceToView(self, 0);
        self.imageView.image = [UIImage imageNamed:@"wd_list_ico_attachment"];
        self.textLabel.text = @"附近舞队";
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }else {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = kLineColor;
        [self sd_addSubviews:@[lineView]];
        lineView.sd_layout
        .leftSpaceToView(self, 30)
        .rightSpaceToView(self, 30)
        .heightIs(1)
        .topSpaceToView(self, 0);
        self.imageView.image = [UIImage imageNamed:@"wd_list_ico_attachment"];
        self.textLabel.text = @"好友列表";
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
