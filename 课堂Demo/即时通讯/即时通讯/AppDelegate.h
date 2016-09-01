//
//  AppDelegate.h
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVIMClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AVIMClient *client;

//切换到首页
- (void)change2HomeVC;

@end

