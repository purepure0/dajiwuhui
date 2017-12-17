//
//  RefuseApplyViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "RefuseApplyOrInviteViewController.h"

@interface RefuseApplyOrInviteViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RefuseApplyOrInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRightItemTitle:@"发送" action:@selector(sendReason)];
    self.view.backgroundColor = kColorRGB(237, 237, 237);
    _textView.backgroundColor = [UIColor whiteColor];
    [_textView becomeFirstResponder];
    
}

- (void)sendReason {
    NSLog(@"%@", _textView.text);
}


- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [_placeHolder setHidden:NO];
    }else {
        [_placeHolder setHidden:YES];
    }
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
