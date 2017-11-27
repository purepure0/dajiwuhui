//
//  EditVideoImageViewController.h
//  SuperDancer
//
//  Created by yu on 2017/10/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectImageBlock)(NSInteger index, UIImage *image);
@interface EditVideoImageViewController : BaseViewController
@property (nonatomic, copy)   NSString *videoURL;
@property (nonatomic, strong) UIImage *tmpImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;

@property (nonatomic, copy)SelectImageBlock selctedBlock;

@end
