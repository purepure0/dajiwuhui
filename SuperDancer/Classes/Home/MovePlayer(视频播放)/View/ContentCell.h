//
//  ContentCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/9.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UICollectionViewCell

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
// 浏览
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;


@end
