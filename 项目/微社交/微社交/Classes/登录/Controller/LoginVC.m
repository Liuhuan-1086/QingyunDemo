//
//  LoginVC.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "LoginVC.h"
#import "Masonry.h"
#import "ItemCard.h"
#import "Account.h"
#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Common.h"



@interface LoginVC ()<ItemCardDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (nonatomic, weak) ItemCard *itemCard;
@property (nonatomic, weak) UIView *backgroundView;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self checkItemView];
}

//显示与隐藏密码
- (IBAction)pwdBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.tfPassword endEditing:YES];
    if (sender.selected) {
        self.tfPassword.secureTextEntry = NO;
    } else {
        self.tfPassword.secureTextEntry = YES;
    }
}

//选项视图
- (void)checkItemView {
    //父视图
    UIView *superView = self.navigationController.view.superview;
    //背景视图
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    self.backgroundView = backgroundView;
    [superView addSubview:backgroundView];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHidden:)];
    [backgroundView addGestureRecognizer:tap];
    //添加选项卡视图
     ItemCard *itemCard = [[ItemCard alloc] init];
    itemCard.backgroundColor = [UIColor whiteColor];
    self.itemCard = itemCard;
    self.itemCard.alpha = 0;
    self.itemCard.delegate = self;
    [superView addSubview:itemCard];
    [itemCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(superView);
        make.width.height.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
}

//点击隐藏
- (void)tapHidden:(UITapGestureRecognizer *)tap {
    __weak typeof(self) w_self = self;
    [UIView animateWithDuration:0.25 animations:^{
        w_self.backgroundView.alpha = 0;
        w_self.itemCard.alpha = 0;
    }];
}

//登录
- (IBAction)loginBtn:(id)sender {
    if (self.tfUserName.text.length == 0 || self.tfPassword.text.length == 0) {
        NSLog(@"content nil");
        NSString *message = @"用户名或密码不能为空";
        [self alertController:message Error:nil];
        return;
    }
    BOOL isEmail = [self validateContent:self.tfUserName.text
                                   Regex:kEmailRegex];
    BOOL isPhoneNum = [self validateContent:self.tfUserName.text
                                      Regex:kPhoneRegex];
    BOOL isPassword = [self validateContent:self.tfPassword.text
                                      Regex:kPassWordRegex];
    BOOL isUserName = [self validateContent:self.tfUserName.text
                                      Regex:kUserNameRegex];
    if (isPassword) {
        if (isPhoneNum) {
            [AVUser logInWithMobilePhoneNumberInBackground: self.tfUserName.text password:self.tfPassword.text block:^(AVUser *user, NSError *error) {
                if (user != nil) {
                    [self loginSuccess:user];
                } else {
                    NSLog(@"%@", error);
                    [self alertController:nil Error:error];
                    return ;
                }
            }];
            
        }else if( isEmail || isUserName) {
             [AVUser logInWithUsernameInBackground:self.tfUserName.text password:self.tfPassword.text block:^(AVUser *user, NSError *error) {
                if (user != nil) {
                    [self loginSuccess:user];
                } else {
                    NSLog(@"%@", error);
                    [self alertController:nil Error:error];
                    return ;
                }
            }];
                     
        }else {
            NSLog(@"username error");
            NSString *message = @"username error";
            [self alertController:message Error:nil];
            return;
        }
    }else {
        NSLog(@"password error");
        NSString *message = @"password error";
        [self alertController:message Error:nil];
    }
}

////登陆成功后的操作
//- (void)loginSuccess:(AVUser *)user {
//    //保存
//    NSDictionary *dictData = @{@"username":user.username, @"objectId":user.objectId};
//    [[Account shareAccount] save:dictData];
//    //切换跟视图控制器
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app changetoHome];
//}

//选择找回密码的方式
- (IBAction)fogetPwdBtn:(id)sender {
    __weak typeof(self) w_self = self;
    [UIView animateWithDuration:0.25 animations:^{
        w_self.backgroundView.alpha = 0.4;
        w_self.itemCard.alpha = 1;
    }];
}

//微博登录
- (IBAction)wbLogin:(id)sender {
    }

//微信登录
- (IBAction)wxLogin:(id)sender {
    
}

#pragma mark - itemCard delegate

- (void)pushToViewController:(UIViewController *)vc {
    __weak typeof(self) w_self = self;
    [UIView animateWithDuration:0.25 animations:^{
        w_self.itemCard.alpha = 0;
        w_self.backgroundView.alpha = 0;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
