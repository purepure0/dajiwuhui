//
//  FriendListCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
