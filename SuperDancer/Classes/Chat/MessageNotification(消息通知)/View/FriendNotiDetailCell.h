//
//  FriendNotiDetailCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendNotiDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *personIntro;


+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)updateFirstCellWithAvatarUrl:(NSString *)avatarUrl nickname:(NSString *)nickname city:(NSString *)city;

- (void)updateSecondCellWithpersonIntro:(NSString *)intro;

@end
