//
//  MusicDownloadViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MusicDownloadViewController.h"

@interface MusicDownloadViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *musicList;

@end

@implementation MusicDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicList.count;
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"音乐";
    }
    return cell;
}


//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return IMAGE_NAMED(@"nodata");
//}
//
//-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView {
//    return YES;
//}

- (NSMutableArray *)musicList {
    if (_musicList == nil) {
        _musicList = [NSMutableArray array];
    }
    return _musicList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
