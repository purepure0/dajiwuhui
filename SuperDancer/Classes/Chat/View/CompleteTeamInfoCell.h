//
//  CompleteTeamInfoCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteTeamInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UIButton *changeAvatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;


@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (instancetype)initWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
