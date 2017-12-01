//
//  MineHandleCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleBlock)(NSInteger index);

@interface MineHandleCell : UITableViewCell

@property (nonatomic, copy) HandleBlock handleBlock;

@end
