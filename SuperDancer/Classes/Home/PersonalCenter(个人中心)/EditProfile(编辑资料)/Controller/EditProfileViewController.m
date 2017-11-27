//
//  EditProfileViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditNickNameViewController.h"
#import <QiniuSDK.h>

#define kAcountBtnImgNotification @"AcountBtnImgNotification"

@interface EditProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UIImagePickerController *imagePicker;


@property (nonatomic, strong)UITextView *introduceTextView;
@property (nonatomic, strong)UILabel *textViewPlaceHolder;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kAutoWidth(55);
    } else {
        if (indexPath.row == 0) {
            return kAutoWidth(55);
        } else {
            return kAutoWidth(100);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:SYSTEM_FONT(16)];
        [cell.textLabel setTextColor:kColorHexStr(@"#212121")];
        cell.textLabel.text = self.titles[indexPath.section][indexPath.row][@"title"];
        
        UIView *lineView = [[UIView alloc] init];
        [cell.contentView addSubview:lineView];
        lineView.backgroundColor = kLineColor;
        lineView.sd_layout
        .leftSpaceToView(cell.contentView, 15)
        .rightEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        .heightIs(0.5);
        
        if (indexPath.section == 0 ) {
            UIImageView *arrowImg = [[UIImageView alloc] init];
            arrowImg.image = IMAGE_NAMED(@"arrow_right");
            arrowImg.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:arrowImg];
            arrowImg.sd_layout
            .rightSpaceToView(cell.contentView, 15)
            .centerYEqualToView(cell.contentView)
            .widthIs(8)
            .heightIs(12);
            
            if (indexPath.row == 0) {
                UIImageView *avatarImgView = [[UIImageView alloc] init];
                self.avatarImgView = avatarImgView;
                avatarImgView.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:avatarImgView];
                
                avatarImgView.sd_layout
                .rightSpaceToView(cell.contentView, 33)
                .centerYEqualToView(cell.contentView)
                .widthIs(40)
                .heightEqualToWidth();
                avatarImgView.sd_cornerRadius = @(20);
            } else {
                self.nickNameLabel = [[UILabel alloc] init];
                self.nickNameLabel.text = self.users.nickName;
                self.nickNameLabel.font = SYSTEM_FONT(14);
                self.nickNameLabel.textColor = kColorHexStr(@"#757575");
                [cell.contentView addSubview:self.nickNameLabel];
                [self.nickNameLabel setSingleLineAutoResizeWithMaxWidth:300];
                self.nickNameLabel.sd_layout
                .rightSpaceToView(cell.contentView, 33)
                .centerYEqualToView(cell.contentView)
                .heightIs(21);
                
            }
        } else {
            if (indexPath.row != 0) {
                
                self.introduceTextView = [[UITextView alloc] init];
                self.introduceTextView.delegate = self;
                [cell.contentView addSubview:self.introduceTextView];
                self.introduceTextView.scrollEnabled = NO;
                self.introduceTextView.font = [UIFont systemFontOfSize:14];
                self.introduceTextView.textColor = kColorRGB(189, 189, 189);
                self.introduceTextView.sd_layout
                .leftSpaceToView(cell.contentView, 15)
                .rightSpaceToView(cell.contentView, 15)
                .topSpaceToView(cell.contentView, 10)
                .bottomSpaceToView(cell.contentView, 10);
                
                self.textViewPlaceHolder = [[UILabel alloc] init];
                [self.introduceTextView addSubview:self.textViewPlaceHolder];
                self.textViewPlaceHolder.text = @"介绍一下自己吧~";
                self.textViewPlaceHolder.font = [UIFont systemFontOfSize:14];
                self.textViewPlaceHolder.textColor = kColorRGB(189, 189, 189);
                self.textViewPlaceHolder.sd_layout
                .leftSpaceToView(self.introduceTextView, 5)
                .rightSpaceToView(self.introduceTextView, 0)
                .topSpaceToView(self.introduceTextView, 6)
                .heightIs(20);
                
                if (self.users.signature.length > 0) {
                    self.introduceTextView.text = self.users.signature;
                    [self.textViewPlaceHolder setHidden:YES];
                }
                
            }
        }
    }
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.users.avatarURL] placeholderImage:IMAGE_NAMED(@"myaccount")];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self uploadImage];
        } else {
            PPLog(@"修改昵称");
            NSLog(@"%@", self.nickNameLabel.text);
            EditNickNameViewController *editNickName = [[EditNickNameViewController alloc] init];
            editNickName.nickNameLabel = self.nickNameLabel;
            [self.navigationController pushViewController:editNickName animated:YES];
        }
    }
}

- (void)uploadImage {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改头像" message:@"选择头像位置" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *fromCamera = [UIAlertAction actionWithTitle:@"从相机选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    fromCamera.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    UIAlertAction *fromGallery = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:fromGallery];
    [alertController addAction:fromCamera];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *avatar;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        avatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        avatar = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    // url = /Users/yu/Library/Developer/CoreSimulator/Devices/9B59425D-ACD9-4E27-873F-FA7E49DDD1D1/data/Containers/Data/Application/50F6E97D-903A-493B-81A7-C1F128C7C35D/tmp/73255181-2D42-4E42-AD3C-4ABC239855E1.jpeg
//    PPLog(@"url = %@",[info objectForKey:UIImagePickerControllerImageURL]);
//    PPLog(@"imagepickerContoller info = %@",info);

    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@",kApiPrefix,KQiniuToken) parameters:nil success:^(id responseObject) {
        [self hideLoading];
        
        NSString *token = responseObject[@"data"][@"res"][@"token"];
//        PPLog(@"七牛token = %@",token);
        NSData *imageData = UIImageJPEGRepresentation(avatar, 0.5f);
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        [upManager putData:imageData key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      PPLog(@"Qiniu info = %@", info);
                      PPLog(@"Qiniu resp = %@", resp);
                      PPLog(@"Qiniu key = %@", key);
                      if (info.ok) {
                          PPLog(@"成功");
                          NSString *imgUrl = NSStringFormat(@"%@%@", kQiniuURLHost, resp[@"key"]);
                          [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kUserUpdata) parameters:@{@"user_headimg": imgUrl} success:^(id responseObject) {
                              PPLog(@"%@", responseObject);
                              NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
                              if ([code isEqualToString:@"0"]) {
                                  [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
                                  self.avatarImgView.image = avatar;
                                  self.users.avatarURL = responseObject[@"data"][@"res"][@"user_headimg"];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:kAcountBtnImgNotification object:nil];
                                  
                              }
                          } failure:^(NSError *error) {
                              PPLog(@"%@", error);
                          }];
                      } else {
                          PPLog(@"失败");
                      }
                  } option:nil];
        
//        PPLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}



- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}


-(NSArray *)titles {
    if (!_titles) {
        _titles = @[
        @[@{@"title":@"头像"},@{@"title":@"昵称"}],
        @[@{@"title":@"个人简介"},@{@"title":@""}]
                  ];
    }
    return _titles;
}


#pragma mark -- TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0) {
        [self.textViewPlaceHolder setHidden:YES];
    }else {
        [self.textViewPlaceHolder setHidden:NO];
    }
    if ([self.introduceTextView.text isEqualToString:self.users.signature]) {
        [self showSaveBtn:NO];
    }else {
        [self showSaveBtn:YES];
    }
}

- (void)showSaveBtn:(BOOL)isShow {
    if (isShow) {
//        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//        [saveBtn setTitleColor:kColorRGB(117, 117, 117) forState:UIControlStateNormal];
//        [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
//        rightItem.customView = saveBtn;
//        self.navigationItem.rightBarButtonItem = rightItem;
        [self setRightItemTitle:@"保存" action:@selector(save)];
    }else {
        self.navigationItem.rightBarButtonItems = nil;
    }
}

- (void)save {
    
    [self hideLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kUserUpdata) parameters:@{@"signature": _introduceTextView.text} success:^(id responseObject) {
        [self hideLoading];
        NSLog(@"%@", responseObject);
        NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
        
        if ([code isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
            self.introduceTextView.text = responseObject[@"data"][@"res"][@"signature"];
            self.users.signature = responseObject[@"data"][@"res"][@"signature"];
            [self showSaveBtn:NO];
            [self.view endEditing:YES];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        PPLog(@"%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
