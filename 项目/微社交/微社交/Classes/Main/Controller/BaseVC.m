//
//  BaseVC.m
//  微社交
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "BaseVC.h"
#import "Account.h"
#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _weakSelf = self;
    _userDef = [NSUserDefaults standardUserDefaults];
}

- (UIImage *)imageFromBase64String:(NSString *)base64String {
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:imageData];
}

- (NSString *)base64StringFromImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64String;
}

//登陆成功后的操作
- (void)loginSuccess:(AVUser *)user {
    //头像
    if (![user objectForKey:@"imageData"]) {
        [user setObject:UIImagePNGRepresentation([UIImage imageNamed:@"header_image"]) forKey:@"imageData"];
        [user saveInBackground];
    }
    if ([user objectForKey:@"email"]) {
        [user setObject:UIImagePNGRepresentation([UIImage imageNamed:@"bg_picture"]) forKey:@"emailData"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"==================succeed");
            } else {
                NSLog(@"==================error");
            }
        }];
    }
    if ([user objectForKey:@"mobilePhoneNumber"]) {
        [user setObject:UIImagePNGRepresentation([UIImage imageNamed:@"home_26x26_"]) forKey:@"phoneData"];
        [user saveInBackground];
    }
    //保存
    NSDictionary *dictData = @{@"username":user.username, @"objectId":user.objectId};
    [[Account shareAccount] save:dictData];
    //切换跟视图控制器
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app changetoHome];
}

- (void)rightBarButtonItemWithCustomView:(UIButton *)button {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)rightBarButtonItemWithImage:(UIImage *)image Selector:(SEL)action{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:action];
}

//提示框
- (void)alertController:(NSString *)message Error:(NSError *)error {
    NSString *strMessage = nil;
    UIAlertController *vcAlert = nil;
    if (message == nil && error != nil) {
        strMessage = [NSString stringWithFormat:@"error: %@",error];
    }else if(message != nil && error == nil){
        strMessage = [NSString stringWithFormat:@"error: %@",message];
    }
    vcAlert = [UIAlertController
               alertControllerWithTitle:@"提示"
               message:strMessage
               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [vcAlert addAction:action];
    [self presentViewController:vcAlert animated:YES completion:nil];
}

//验证输入是否正确
- (BOOL)validateContent:(NSString *)strContent Regex:(NSString *)strRegex {
    //谓词
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pred evaluateWithObject:strContent];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
