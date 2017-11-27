//
//  SelectTypeView.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SelectTypeView.h"
#import "SelectTypeCell.h"
#import "DanceTypeModel.h"
#define kSelectTypeCellIdentifier @"SelectTypeCellIdentifier"
#define kSelectTypeHeaderIdentifier @"SelectTypeHeaderIdentifier"
@implementation SelectTypeView
{
    NSMutableArray *_groundTypeList;
    NSMutableArray *_childrenTypeList;
    NSString *_topid;
    NSString *_tid;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTopView];
        _groundTypeList = [[NSMutableArray alloc] init];
        _childrenTypeList = [[NSMutableArray alloc] init];
        [self initDataSource];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 49, frame.size.width, frame.size.height - 49) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:NIB_NAMED(@"SelectTypeCell") forCellWithReuseIdentifier:kSelectTypeCellIdentifier];;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSelectTypeHeaderIdentifier];
        [self addSubview:_collectionView];
    }
    return self;
}


- (void)setTopView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 49)];
    label.textColor = [UIColor blackColor];
    label.text = @"选择分类";
    label.font = [UIFont systemFontOfSize:18];
    [self addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 49, 45)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:kColorRGB(90, 180, 50) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)click:(UIButton *)btn {
    if (_topid.length == 0 || _tid.length == 0) {
        [MBProgressHUD showError:@"请选择分类" toView:kKeyWindow];
    }else {
        if (_block) {
            _block(_topid, _tid);
        }
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%@%@", _groundTypeList, _childrenTypeList);
    if (section == 0) {
        return _groundTypeList.count;
    }else {
        return _childrenTypeList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectTypeCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        DanceTypeModel *model = _groundTypeList[indexPath.row];
        NSLog(@"%@", model.tname);
        cell.model = model;
    }else {
        DanceTypeModel *model = _childrenTypeList[indexPath.row];
        NSLog(@"%@", model.tname);
        cell.model = model;

    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 100) / 3, kAutoWidth(35));
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kAutoWidth(15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kAutoWidth(15);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSelectTypeHeaderIdentifier forIndexPath:indexPath];
        headerView.backgroundColor = kColorRGB(249, 249, 249);

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, kAutoWidth(25))];
        label.textColor = kColorRGB(189, 189, 189);
        if (indexPath.section == 0) {
            label.text = @"广场舞";
        }else {
            label.text = @"儿童舞";
        }
        [headerView addSubview:label];

        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(self.frame.size.width, kAutoWidth(25));
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _topid = @"3";
        DanceTypeModel *model = _groundTypeList[indexPath.row];
        _tid = [NSString stringWithFormat:@"%@", model.tid];
    }else {
        _topid = @"1";
        DanceTypeModel *model = _childrenTypeList[indexPath.row];
        _tid = [NSString stringWithFormat:@"%@", model.tid];
    }
    
}



- (void)initDataSource {
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kVideoType) parameters:@{@"type": @"3"} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *videoTypeArr = responseObject[@"data"][@"vedioType"];
            for (NSDictionary *dict in videoTypeArr) {
                DanceTypeModel *model = [[DanceTypeModel alloc] initDanceTypeModelWithDict:dict];
                [_groundTypeList addObject:model];
            }
            [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kVideoType) parameters:@{@"type": @"1"} success:^(id responseObject) {
                NSLog(@"%@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSArray *videoTypeArr = responseObject[@"data"][@"vedioType"];
                    for (NSDictionary *dict in videoTypeArr) {
                        DanceTypeModel *model = [[DanceTypeModel alloc] initDanceTypeModelWithDict:dict];
                        [_childrenTypeList addObject:model];
                    }
                    [self.collectionView reloadData];
                }else {
                    
                }
            } failure:^(NSError *error) {
                PPLog(@"%@", error);
            }];
        }else {
    
        }
    } failure:^(NSError *error) {
        PPLog(@"%@", error);
    }];
    
    
    
}




@end
