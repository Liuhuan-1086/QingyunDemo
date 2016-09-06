//
//  LoginVC.m
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)loginBtn:(id)sender {
    if (self.tfUserName.text == nil || self.tfPwd.text == nil) {
        NSLog(@"username or pwd nil");
        return;
    }
    [AVUser logInWithUsernameInBackground:self.tfUserName.text password:self.tfPwd.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            NSLog(@"登录成功");
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setValue:self.tfUserName.text forKey:@"username"];
            [def synchronize];
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            [app change2HomeVC];
        }else {
            NSLog(@"%@",error);
        }
    }];
}

@end
