//
//  TeamListForChatTableViewCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamListForChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (instancetype)initCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)updateCellWithTeamData:(NIMTeam *)team;

@end
