//
//  MemberManageCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteBlock)(NSInteger _index);

@interface MemberManageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (nonatomic, copy) DeleteBlock deleteBlock;


- (void)layoutSubviews:(BOOL)isEdit;

@end
