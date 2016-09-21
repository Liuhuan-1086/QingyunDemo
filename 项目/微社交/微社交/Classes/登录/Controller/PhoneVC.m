//
//  PhoneVC.m
//  微社交
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "PhoneVC.h"
#import "Common.h"
#import <AVOSCloud/AVOSCloud.h>

@interface PhoneVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *tfSMSCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@end

@implementation PhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
}



//获取并验证短信码
- (IBAction)btnSendSMSCode:(id)sender {
    BOOL isPhone = [self validateContent:self.tfPhoneNum.text Regex:kPhoneRegex];
    if (isPhone) {
        [AVUser requestPasswordResetWithPhoneNumber:self.tfPhoneNum.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSString *message = @"修改成功";
                [self alertController:message Error:nil];
            } else {
                [self alertController:nil Error:error];
            }
        }];
    }
}

//显示或隐藏密码
- (IBAction)pwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.tfPwd endEditing:YES];
    if (sender.selected) {
        self.tfPwd.secureTextEntry = NO;
    }else {
        self.tfPwd.secureTextEntry = YES;
    }
}

//重置密码
- (IBAction)btnRestPwd:(UIButton *)sender {
    if (self.tfPhoneNum.text.length == 0 || self.tfSMSCode.text.length == 0 || self.tfPwd.text.length == 0) {
        NSString *message = @"文本框不能为空";
        [self alertController:message Error:nil];
        return;
    }
    BOOL isPhone = [self validateContent:self.tfPhoneNum.text Regex:kPhoneRegex];
    BOOL isPassword = [self validateContent:self.tfPwd.text Regex:kPassWordRegex];
    if (self.tfSMSCode.text.length == 6) {
        if (isPhone) {
            if (isPassword) {
                [AVUser resetPasswordWithSmsCode:self.tfSMSCode.text newPassword:self.tfPwd.text block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSString *message = @"密码重置成功";
                        [self alertController:message Error:nil];
                    } else {
                        [self alertController:nil Error:error];
                    }
                }];
            }else {
                NSString *message = @"密码错误";
                [self alertController:message Error:nil];
            }
        }else {
            NSString *message = @"手机号错误";
            [self alertController:message Error:nil];
        }
    }else {
        NSString *message = @"验证码错误";
        [self alertController:message Error:nil];
    }
}

@end
