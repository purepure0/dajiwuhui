//
//  CreatDanceTeamViewController.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CreatDanceTeamViewController.h"
#import "TZImagePickerController.h"
#import "CompleteTeamInfoViewController.h"
@interface CreatDanceTeamViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *changeTemeHeaderImageViewButton;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong)UIImage *teamImg;
@end

@implementation CreatDanceTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建舞队";
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.layer.cornerRadius = 5;
    self.commitButton.userInteractionEnabled = NO;
    self.teamNameTextField.delegate = self;
    self.changeTemeHeaderImageViewButton.selected = NO;
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-------Action
- (IBAction)changeTemeHeaderImageViewButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]init];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _teamImg = photos[0];
        [weakSelf.changeTemeHeaderImageViewButton setImage:_teamImg forState:UIControlStateNormal];
        if(!weakSelf.changeTemeHeaderImageViewButton.selected){
            weakSelf.changeTemeHeaderImageViewButton.selected = YES;
        }
        if(![weakSelf.teamNameTextField.text isEqualToString:@""]){
            weakSelf.commitButton.backgroundColor = [UIColor colorWithHexString:@"#9a00b9"];
            self.commitButton.userInteractionEnabled = YES;
        }
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
- (IBAction)commitButtonAction:(UIButton *)sender {
    CompleteTeamInfoViewController *teamInfo = [[CompleteTeamInfoViewController alloc] init];
    teamInfo.teamName = _teamNameTextField.text;
    teamInfo.avatarImage = _teamImg;
    [self.navigationController pushViewController:teamInfo animated:YES];
    
}

#pragma mark------UItextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(![textField.text isEqualToString:@""]&&self.changeTemeHeaderImageViewButton.selected) {
        self.commitButton.backgroundColor = [UIColor colorWithHexString:@"#9a00b9"];
        self.commitButton.userInteractionEnabled = YES;
    }
    return YES;
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.teamNameTextField resignFirstResponder];
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
