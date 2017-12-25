//
//  AddFriendViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verMessageTF;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    // Do any additional setup after loading the view from its nib.
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.cornerRadius = 17;
    _addBtn.layer.borderWidth = 1;
    _addBtn.layer.borderColor = kColorRGB(255, 147, 0).CGColor;
}


- (IBAction)addFriend:(id)sender {
    
    NSLog(@"add");
    if (self.telPhoneTF.text.length < 5) {
        [self toast:@"手机号位数不能为零"];
    }else {
        [self searchFriend];
    }
}

- (void)searchFriend {
    
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, @"/im/tel") parameters:@{@"tel": self.telPhoneTF.text} success:^(id responseObject) {
        NSLog(@"resp:%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSString *userID = responseObject[@"data"][@"res"][@"uid"];
            [self sendAddRequestWithUid:userID];
        }else {
            [self toast:@"用户不存在"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
        
    }];
}

- (void)sendAddRequestWithUid:(NSString *)uid {
    
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = [NSString stringWithFormat:@"%@", uid];
    request.operation = NIMUserOperationRequest;
    request.message = self.verMessageTF.text;
    
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        NSLog(@"error:%@", error);
        if (!error) {
            [self toast:@"添加成功"];
        }else {
            [self toast:error.description];
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
