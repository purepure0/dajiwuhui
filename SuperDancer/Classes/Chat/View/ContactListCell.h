//
//  ContactListCell.h
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (instancetype)initCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)updateCellWithName:(NSString *)name info:(NSString *)info imageUrl:(NSString *)imageUrl;
@end
