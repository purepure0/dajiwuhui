//
//  GroupNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "GroupNoticeViewController.h"
#import "PublishNoticeViewController.h"
#import "TeamAnnouncementCell.h"

@interface GroupNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,PublishTeamAnnouncementDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *announcements;

@end

static NSString *kGroupNoticeCellIdentifier = @"GroupNoticeCellIdentifier";

@implementation GroupNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新建舞队公告";
    self.view.backgroundColor = kBackgroundColor;
    [self setRightItemTitle:@"新建" action:@selector(publishAction)];
    
    [self.tableView registerNib:NIB_NAMED(@"TeamAnnouncementCell") forCellReuseIdentifier:@"cell"];
    
    if (self.team.announcement.length) {
        NSArray *data = [NSJSONSerialization JSONObjectWithData:[self.team.announcement dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
        _announcements = [NSMutableArray arrayWithArray:data];
    }
}


#pragma mark - publish Action

- (void)publishAction {
    PublishNoticeViewController *pn = [[PublishNoticeViewController alloc] init];
    pn.delegate = self;
    [self.navigationController pushViewController:pn animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _announcements.lastObject ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *announcement = _announcements.lastObject;
    [cell setData:announcement];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *announcement = _announcements.lastObject;
    return [self.tableView cellHeightForIndexPath:0 model:announcement keyPath:@"data" cellClass:[TeamAnnouncementCell class] contentViewWidth:kScreenWidth];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - PublishTeamAnnouncementDelegate

- (void)publishTeamAnnouncementCompleteWithTitle:(NSString *)title content:(NSString *)content {
    if (title.length && content.length) {
        NSDictionary *announcement = @{@"title": title,
                                       @"content": content,
                                       @"creator": [[NIMSDK sharedSDK].userManager userInfo:self.team.owner].userInfo.nickName,
                                       @"time": @((NSInteger)[NSDate date].timeIntervalSince1970)};
        NSData *data = [NSJSONSerialization dataWithJSONObject:@[announcement] options:0 error:nil];
        self.team.announcement = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        self.team.announcement = nil;
    }
    
    [self.hud show:YES];
    [[NIMSDK sharedSDK].teamManager updateTeamAnnouncement:[self.team.announcement copy] teamId:self.team.teamId completion:^(NSError *error) {
        [self.hud hide:YES];
        if(!error) {
            [self toast:@"新建公告成功"];
            if (self.team.announcement.length) {
                NSArray *data = [NSJSONSerialization JSONObjectWithData:[self.team.announcement dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
                self.announcements = [NSMutableArray arrayWithArray:data];
            }else{
                self.announcements = nil;
            }
            
            [self.tableView reloadData];
        } else {
            PPLog(@"updateTeamAnnouncement error = %@",error.description);
            [self toast:@"新建公告失败"];
        }
    }];
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
