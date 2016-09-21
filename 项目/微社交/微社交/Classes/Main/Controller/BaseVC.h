//
//  BaseVC.h
//  微社交
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVUser;

@interface BaseVC : UIViewController
{
    __weak BaseVC *_weakSelf;
    __strong NSUserDefaults *_userDef;
}

//登陆成功后的操作
- (void)loginSuccess:(AVUser *)user;

//UIImage 转化为 base64String
- (NSString *)base64StringFromImage:(UIImage *)image;

//base64String 转化为 UIImage
- (UIImage *)imageFromBase64String:(NSString *)base64String;

//提示框
- (void)alertController:(NSString *)message Error:(NSError *)error;
- (void)rightBarButtonItemWithCustomView:(UIButton *)button;
- (void)rightBarButtonItemWithImage:(UIImage *)image Selector:(SEL)action;

//正则验证
- (BOOL)validateContent:(NSString *)strContent Regex:(NSString *)strRegex;

@end
