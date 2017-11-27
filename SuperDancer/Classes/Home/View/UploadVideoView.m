//
//  UploadVideoView.m
//  SuperDancer
//
//  Created by yu on 2017/10/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "UploadVideoView.h"

@implementation UploadVideoView

- (IBAction)exitAction:(id)sender {
    if (self.exitBlock) {
        self.exitBlock();
    }
}

- (IBAction)shootAction:(id)sender {
    if (self.shootBlock) {
        self.shootBlock();
    }
}

- (IBAction)chooseAction:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock();
    }
}

@end
