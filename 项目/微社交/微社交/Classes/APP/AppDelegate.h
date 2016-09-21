//
//  AppDelegate.h
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) AVIMClient *client;
@property (strong, nonatomic) UIWindow *window;

- (void)changetoHome;

@end

