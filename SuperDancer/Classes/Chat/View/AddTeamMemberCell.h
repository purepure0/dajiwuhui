//
//  AddTeamMemberCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MemberSelectedBlock) (NSString *userId);

@interface AddTeamMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)MemberSelectedBlock selectedBlock;

@end
