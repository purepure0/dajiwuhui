//
//  ScrollViewCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScrollViewCell;
@protocol ScrollViewCellDelegate <NSObject>

- (void)applyJoinTeamButtonAction:(ScrollViewCell *)scrollViewCell;

@end

@interface ScrollViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyJoinBtn;

@property (nonatomic, weak) id<ScrollViewCellDelegate> delegate;

@end
