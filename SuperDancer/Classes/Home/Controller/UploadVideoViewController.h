//
//  UploadVideoViewController.h
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadVideoViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *editImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (nonatomic, assign) UIImagePickerControllerSourceType soureType;


@end
