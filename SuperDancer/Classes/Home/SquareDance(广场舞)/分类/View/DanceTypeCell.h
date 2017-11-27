//
//  DanceTypeCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanceTypeModel.h"
@interface DanceTypeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic, strong)DanceTypeModel *model;
@end
