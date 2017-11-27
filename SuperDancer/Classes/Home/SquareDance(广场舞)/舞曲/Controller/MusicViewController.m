//
//  MusicViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicModel.h"
#import "MusicViewCell.h"
#import "MusicModel.h"
#import "MusicVideoViewController.h"
#define kMusciCellIdentifier @"MusicCellIdentifier"
@interface MusicViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *musicList;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"舞曲";
    [self initDataSource];
    
    _tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:NIB_NAMED(@"MusicViewCell") forCellReuseIdentifier:kMusciCellIdentifier];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MusicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusciCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleArr = @[@"热门榜", @"最新榜", @"推荐"];
    cell.typeLabel.text = titleArr[indexPath.row];
    
    NSArray *colorArr = @[kColorRGB(48, 35, 174), kColorRGB(180, 236, 81), kColorRGB(250, 217, 97)];
    cell.imgView.backgroundColor = colorArr[indexPath.row];
    
    NSArray *arr = _musicList[indexPath.row];
    [cell setMusicList:arr];
    cell.selectedBlock = ^(MusicModel *model) {
        MusicVideoViewController *musicVideo = [[MusicVideoViewController alloc] init];
        musicVideo.title = model.title;
        musicVideo.musicId = model.mid;
        [self.navigationController pushViewController:musicVideo animated:YES];
    };
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicList.count;
}


- (void)initDataSource {
    [self showLoading];
    _musicList = [NSMutableArray new];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kMusic) parameters:@{@"type": self.type} success:^(id responseObject) {
        [self hideLoading];
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //TOP
            NSArray *topArr = responseObject[@"data"][@"res"][@"top"];
            NSMutableArray *topMusic = [NSMutableArray new];
            for (NSDictionary *dict in topArr) {
                MusicModel *model = [[MusicModel alloc] initMusicModelWithDict:dict];
                [topMusic addObject:model];
            }
            [_musicList addObject:topMusic];
            //NEW
            NSArray *newArr = responseObject[@"data"][@"res"][@"new"];
            NSMutableArray *newMusic = [NSMutableArray new];
            for (NSDictionary *dict in newArr) {
                MusicModel *model = [[MusicModel alloc] initMusicModelWithDict:dict];
                [newMusic addObject:model];
            }
            [_musicList addObject:newMusic];
            //RECOMMEND
            NSArray *recommendArr = responseObject[@"data"][@"res"][@"recommend"];
            NSMutableArray *recommendMusic = [NSMutableArray new];
            for (NSDictionary *dict in recommendArr) {
                MusicModel *model = [[MusicModel alloc] initMusicModelWithDict:dict];
                [recommendMusic addObject:model];
            }
            [_musicList addObject:recommendMusic];
            [_tableView reloadData];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [self hideLoading];
        PPLog(@"%@", error);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





@end
