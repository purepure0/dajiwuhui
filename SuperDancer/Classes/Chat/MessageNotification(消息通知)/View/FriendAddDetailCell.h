//
//  FriendAddDetailCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendAddDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

//@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


- (void)updateFirstCellWithAvatarUrl:(NSString *)avatarUrl nickname:(NSString *)nickname;

- (void)updateSecondCellWithTitle:(NSString *)title content:(NSString *)content;

- (void)updateThirdCellWithTitle:(NSString *)title introduction:(NSString *)intro;

@end
