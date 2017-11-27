//
//  DanceTypeViewController.h
//  SuperDancer
//
//  Created by yu on 2017/10/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface DanceTypeViewController : BaseViewController<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
