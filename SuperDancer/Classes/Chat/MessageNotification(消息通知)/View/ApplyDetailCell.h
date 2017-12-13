//
//  ApplyDetailCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


- (void)updateFirstCellWithData:(NSDictionary *)data;

- (void)updateSecondCellWithData:(NSDictionary *)data;

- (void)updateThirdCellWithData:(NSDictionary *)data;
@end
