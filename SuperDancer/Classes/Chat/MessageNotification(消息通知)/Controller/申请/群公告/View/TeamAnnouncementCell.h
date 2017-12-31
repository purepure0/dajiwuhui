//
//  TeamAnnouncementCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/31.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamAnnouncementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *InfoLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) NSDictionary *data;

- (void)refreshData:(NSDictionary *)data;

@end
