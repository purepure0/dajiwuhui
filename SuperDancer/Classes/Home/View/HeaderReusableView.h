//
//  HeaderReusableView.h
//  SuperDancer
//
//  Created by yu on 2017/10/6.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end
