//
//  TeamListForChatTableViewCell.h
//  SuperDancer
//
//  Created by 王司坤 on 2017/11/29.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamListForChatTableViewCell : UITableViewCell
-(void)updateCellWithData:(NSDictionary *)infoData;
-(void)updateCellWithArray:(NSArray *)infoData;
@end
