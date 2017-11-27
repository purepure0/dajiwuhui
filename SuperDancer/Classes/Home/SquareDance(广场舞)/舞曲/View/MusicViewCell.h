//
//  MusicViewCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

typedef void(^MusicSelectedBlock)(MusicModel *model);
@interface MusicViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *top1;
@property (weak, nonatomic) IBOutlet UIButton *top2;
@property (weak, nonatomic) IBOutlet UIButton *top3;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, copy) MusicSelectedBlock selectedBlock;
@end
