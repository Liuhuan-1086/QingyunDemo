//
//  MailVC.m
//  微社交
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "MailVC.h"
#import "Common.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MailVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfEmail;

@end

@implementation MailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//重置密码
- (IBAction)btnResetPwd:(UIButton *)sender {
    if (self.tfEmail.text.length == 0) {
        NSString *message = @"邮箱不能为空";
        [self alertController:message Error:nil];
        return;
    }
    //验证邮箱
    BOOL isEmail = [self validateContent:self.tfEmail.text Regex:kEmailRegex];
    if (isEmail) {
        [AVUser requestPasswordResetForEmailInBackground:self.tfEmail.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSString *message = @"发送成功, 请前往邮箱重置密码";
                [self alertController:message Error:nil];
            } else {
                [self alertController:nil Error:error];
            }
        }];
    }else {
        NSString *message = @"邮箱验证失败";
        [self alertController:message Error:nil];
    }
}

//返回登录页
- (IBAction)btnBackLogin:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
