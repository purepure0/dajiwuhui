//
//  HomeCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/6.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
@interface HomeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;

- (void)setModel:(VideoListModel *)model;
    
    
@end
