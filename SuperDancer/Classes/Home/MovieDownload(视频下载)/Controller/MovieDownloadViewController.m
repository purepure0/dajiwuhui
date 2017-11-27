//
//  MovieDownloadViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/11.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MovieDownloadViewController.h"
#import "ZFDownloadManager.h"
#import "ZFPlayer.h"

#import "DownloadingCell.h"
#import "DownloadedCell.h"

#import "MovePlayerViewController.h"

#define kDownloadingCellIdentifier @"DownloadingCell"
#define kDownloadedCellIdentifier @"DownloadedCell"

#define DownloadManager [ZFDownloadManager sharedDownloadManager]

@interface MovieDownloadViewController ()<UITableViewDataSource,UITableViewDelegate,ZFDownloadDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *videoList;

@end

@implementation MovieDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"离线缓存";
    [self.tableView registerNib:NIB_NAMED(@"DownloadingCell") forCellReuseIdentifier:kDownloadingCellIdentifier];
    [self.tableView registerNib:NIB_NAMED(@"DownloadedCell") forCellReuseIdentifier:kDownloadedCellIdentifier];
    DownloadManager.downloadDelegate = self;
//    PPLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
//    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDownloadData];
}

- (void)initDownloadData
{
    [DownloadManager startLoad];
    NSMutableArray *downloading = DownloadManager.downinglist;
    NSMutableArray *downladed = DownloadManager.finishedlist;
    [self.videoList addObject:downloading];
    [self.videoList addObject:downladed];
    [self.tableView reloadData];
    
//    PPLog(@"count = %ld",[self.videoList.firstObject count]);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return IMAGE_NAMED(@"nodata");
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView {
    return YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videoList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 正在缓存*/
    if (indexPath.section == 0) {
        DownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:kDownloadingCellIdentifier];
        
        ZFHttpRequest *request = self.videoList[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        cell.fileInfo = fileInfo;
//        PPLog(@"** fileId ** = %@",fileInfo.fileId);
        return cell;
        
    /** 缓存完成*/
    } else {
        DownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:kDownloadedCellIdentifier];
        ZFFileModel *fileInfo = self.videoList[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
//        PPLog(@"fileId哈哈哈 = %@",fileInfo.fileId);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAutoWidth(85);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *sectionTitle = nil;
    sectionTitle = (section == 0) ? @"正在缓存" : @"已缓存";
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *downloadingLabel = [[UILabel alloc] init];
    downloadingLabel.text = sectionTitle;
    downloadingLabel.font = SYSTEM_FONT(12);
    downloadingLabel.textColor = kTextGrayColor;
    [bgView addSubview:downloadingLabel];
    
    downloadingLabel.sd_layout.leftSpaceToView(bgView, 15).heightRatioToView(bgView, 1).rightEqualToView(bgView);
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.videoList[section] count] == 0 ? 0:kAutoWidth(25);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        ZFFileModel *model = self.videoList[indexPath.section][indexPath.row];
        
        NSString *path = FILE_PATH(model.fileName);
        NSURL *videoURL = [NSURL fileURLWithPath:path];
        
        MovePlayerViewController *movie = [[MovePlayerViewController alloc] init];
        //    NSString *url = [videoURL absoluteString];
        //    PPLog(@"00000=%@",path);
        
        movie.videoURL = videoURL;
        //    PPLog(@"@@@@@videoURL == %@",videoURL);
        movie.vid = model.fileId;
        
        [self.navigationController pushViewController:movie animated:YES];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFHttpRequest *request = self.videoList[indexPath.section][indexPath.row];
        [DownloadManager deleteRequest:request];
    } else {
        ZFFileModel *fileInfo = self.videoList[indexPath.section][indexPath.row];
        [DownloadManager deleteFinishFile:fileInfo];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [tableView reloadData];
}

#pragma mark - ZFDownloadDelegate

/** 开始下载*/
- (void)startDownload:(ZFHttpRequest *)request {
    PPLog(@"开始下载!");
}

/** 下载中*/
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

/** 下载完成*/
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self initDownloadData];
}

/** 更新下载进度*/
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    NSArray *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[DownloadingCell class]]) {
            DownloadingCell *cell = (DownloadingCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

- (NSMutableArray *)videoList
{
    if (_videoList == nil) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
