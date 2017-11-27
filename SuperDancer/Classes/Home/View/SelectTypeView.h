//
//  SelectTypeView.h
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBlock)(NSString *topid, NSString *tid);
@interface SelectTypeView : UIView<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, copy)SelectBlock block;


@end
