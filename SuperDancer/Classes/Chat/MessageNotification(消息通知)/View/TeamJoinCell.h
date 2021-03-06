//
//  TeamJoinCell.h
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^HandleBtnBlock)(NSInteger index);

typedef void(^QRCodeBlock)(void);

typedef void(^AddMemberBlock)(void);

typedef void(^IconImgBlock)(void);


@interface TeamJoinCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIButton *qcodeBtn;

@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout2;


@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;




//@property (nonatomic, copy) HandleBtnBlock handleBtnBlock;

@property (nonatomic, copy) QRCodeBlock qRCodeBlock;

@property (nonatomic, copy) AddMemberBlock addMemberBlock;

@property (nonatomic, copy) IconImgBlock iconImgBlock;

+ (instancetype)initTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath joined:(BOOL)joined;
+ (instancetype)initWithTableView:(UITableView *)tableView andIndex:(NSInteger)index;

- (void)updateFirstCellWithData:(NSDictionary *)data;

- (void)updateSecondCellWithData:(NSDictionary *)data;

- (void)updateThirdCellWithData:(NSDictionary *)data;

- (void)updateFourthCellWithData:(NSDictionary *)data;

- (void)updateFifthCellWithData:(NSArray<NIMUser *> *)members;


//是否显示右边的箭头
- (void)showRigthArrow:(BOOL)isShow;
@end
