//
//  RegVC.m
//  微社交
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "RegistVC.h"
#import "Common.h"
#import "Account.h"
#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RegistVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.tfPwd endEditing:YES];
    if (sender.selected) {
        self.tfPwd.secureTextEntry = NO;
    }else {
        self.tfPwd.secureTextEntry = YES;
    }
}

//注册按钮
- (IBAction)btnRegister:(UIButton *)sender {
    if (self.tfUserName.text.length == 0 || self.tfPwd.text.length == 0 || self.tfAccount.text.length == 0) {
        NSLog(@"content nil");
        NSString *message = @"用户名或密码不能为空";
        [self alertController:message Error:nil];
        return;
    }
    BOOL isEmail = [self validateContent:self.tfAccount.text
                                   Regex:kEmailRegex];
    BOOL isPhoneNum = [self validateContent:self.tfAccount.text
                                      Regex:kPhoneRegex];
    BOOL isPassword = [self validateContent:self.tfPwd.text
                                      Regex:kPassWordRegex];
    BOOL isUserName = [self validateContent:self.tfUserName.text
                                      Regex:kUserNameRegex];
    if (isPassword && isUserName) {
        if (isPhoneNum) {
            //phonenum pwd register
            AVUser *user = [AVUser user];// 新建 AVUser 对象实例
            user.username = self.tfUserName.text;// 设置用户名
            user.password =  self.tfPwd.text;// 设置密码
            user.mobilePhoneNumber = self.tfAccount.text;// 设置手机号
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    [self loginSuccess:user];
                } else {
                    // 失败的原因可能有多种，常见的是用户名已经存在。
                    NSLog(@"%@",error);
                    [self alertController:nil Error:error];
                    return;
                }
            }];
        }else if (isEmail) {
            //email pwd register
            AVUser *user = [AVUser user];// 新建 AVUser 对象实例
            user.username = self.tfUserName.text;// 设置用户名
            user.password =  self.tfPwd.text;// 设置密码
            user.email = self.tfAccount.text;// 设置邮箱
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // 注册成功
                    [self loginSuccess:user];
                } else {
                    // 失败的原因可能有多种，常见的是用户名已经存在。
                    NSLog(@"%@",error);
                    [self alertController:nil Error:error];
                    return;
                }
            }];
        }else {
            NSString *message = @"please check phonenum or email register";
            [self alertController:message Error:nil];
        }
    }else {
        NSString *message = @"username or password or account error";
        [self alertController:message Error:nil];
    }
}

////登陆成功后的操作
//- (void)loginSuccess:(AVUser *)user {
//    //设置头像
//    [user setObject:@(NO) forKey:@"isHeadImage"];
//    [user saveInBackground];
//    //保存
//    NSDictionary *dictData = @{@"username":user.username, @"objectId":user.objectId};
//    [[Account shareAccount] save:dictData];
//    //切换跟视图控制器
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app changetoHome];
//}

@end
