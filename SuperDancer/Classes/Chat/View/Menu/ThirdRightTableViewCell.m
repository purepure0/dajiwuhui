//
//  ThirdRightTableViewCell.m
//  Frame
//
//  Created by 栗子 on 2017/9/7.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "ThirdRightTableViewCell.h"

@implementation ThirdRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self addSubvies];
    }
    return self;

}

-(void)addSubvies{
    self.iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    [self.contentView addSubview:self.iconIV];
    self.iconIV.layer.cornerRadius = 25;
    self.iconIV.layer.masksToBounds = YES;
    
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconIV.frame)+10, 15, 200, 20)];
    [self.contentView addSubview:self.titleLB];
    
    
}

-(void)iconiv:(UIImage *)image titleText:(NSString *)text{
    self.iconIV.image = image;
    
    self.titleLB.text = text;

}

@end
