//
//  ViewController.m
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RegisterVC.h"
#import "AppDelegate.h"
#import "AVOSCloud/AVOSCloud.h"

@interface RegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/** 注册账号 */
- (IBAction)registerBtn:(id)sender {
    if (self.tfUserName.text == nil || self.tfPwd.text == nil) {
        NSLog(@"name or pwd nil");
        return;
    }
    //创建用户
    AVUser *user = [AVUser user];
    user.username = self.tfUserName.text;
    user.password = self.tfPwd.text;
    //保存用异步模式
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setValue:user.username forKey:@"username"];
            [def synchronize];
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            [app change2HomeVC];
        }else {
            NSLog(@"%@",error);
        }
    }];
}

@end
