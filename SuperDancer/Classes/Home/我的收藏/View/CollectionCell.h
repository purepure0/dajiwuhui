//
//  CollectionCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@interface CollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *tLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (nonatomic, strong) CollectionModel *model;

@end
