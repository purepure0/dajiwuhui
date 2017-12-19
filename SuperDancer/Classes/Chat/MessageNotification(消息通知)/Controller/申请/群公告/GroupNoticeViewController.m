//
//  GroupNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "GroupNoticeViewController.h"
#import "PublishNoticeViewController.h"
#import "GroupNoticeCell.h"
#import "GroupNoticeModel.h"
#import "GroupNoticeDetailViewController.h"

@interface GroupNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *noticeList;

@end

static NSString *kGroupNoticeCellIdentifier = @"GroupNoticeCellIdentifier";

@implementation GroupNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"舞队公告";
    self.view.backgroundColor = kBackgroundColor;
    [self setRightItemTitle:@"发布" action:@selector(publishAction)];
    
    [self creatModelsWithCount:10];
    
    [self.tableView registerNib:NIB_NAMED(@"GroupNoticeCell") forCellReuseIdentifier:kGroupNoticeCellIdentifier];
}


- (void)creatModelsWithCount:(NSInteger)count
{
    if (!_noticeList) {
        _noticeList = [[NSMutableArray alloc] init];
    }
    
    NSArray *imageArray = @[@"dance",@"icon",@"icon",@"dance",@"dance"];
    NSArray *contentArray = @[
    @"2015年主演犯罪悬疑片《杀破狼2》。",
    @"同年，自编自导自演军事战争片《战狼》，并凭借该片获得第33届大众电影百花奖最佳导演奖提名、第22届北京大学生电影节最佳处女作奖、第20届华鼎奖最最佳新锐导演奖[4]。",
    @"2017年自导自演动作片《战狼2》，该片打破中国内地票房纪录以及全球单一市场单片票房纪录[5-6]，凭借该片获得第十四届广州大学生电影节最受大学生欢迎的导演以及最受大学生欢迎的男演员奖[7]、第四届丝绸之路国际电影节突出贡献个人奖[8]、2017中国-东盟电影节最佳影片奖[9]。",
    @"2017年7月27日，由吴京自导自演的动作军事电影《战狼Ⅱ》上映，他在片中饰演英勇果敢的铁血硬汉冷锋；该片上映36天票房突破55亿元，不仅打破中国内地市场票房纪录、全球单一市场单片票房纪录，还成为首部进入全球TOP100票房影片榜的亚洲电影[6][37]。他也凭借该片获得东京电影节中国电影周金鹤奖的最佳导演、最佳影片、最佳男主角[38]。"];
    
    for (int i = 0; i < count; i++) {
        
        int nameRandomIndex = arc4random_uniform(4);
        
        GroupNoticeModel *model = [[GroupNoticeModel alloc] init];
        model.content = contentArray[nameRandomIndex];
        
        // 模拟“有或者无图片”
        int random = arc4random_uniform(1);
        if (random <= 4) {
            NSMutableArray *temp = [NSMutableArray new];
            
            int randomImagesCount = arc4random_uniform(5);
            for (int i = 0; i < randomImagesCount; i++) {
                int randomIndex = arc4random_uniform(5);
                NSString *text = imageArray[randomIndex];
                [temp addObject:text];
            }
            model.imageArray = [temp copy];
        }
        [self.noticeList addObject:model];
    }
}

#pragma mark - publish Action

- (void)publishAction {
    PublishNoticeViewController *pn = [[PublishNoticeViewController alloc] init];
    [self.navigationController pushViewController:pn animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.noticeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupNoticeCellIdentifier];
    GroupNoticeModel *model = self.noticeList[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupNoticeModel *model = self.noticeList[indexPath.section];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[GroupNoticeCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNoticeDetailViewController *detail = [[GroupNoticeDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
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
