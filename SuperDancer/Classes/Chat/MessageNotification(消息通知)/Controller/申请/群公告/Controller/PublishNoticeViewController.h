//
//  PublishNoticeViewController.h
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//  发布公告

#import "BaseViewController.h"

@protocol PublishTeamAnnouncementDelegate <NSObject>

- (void)publishTeamAnnouncementCompleteWithTitle:(NSString *)title content:(NSString *)content;

@end

@interface PublishNoticeViewController : BaseViewController

@property (nonatomic, weak) id<PublishTeamAnnouncementDelegate> delegate;

@end
