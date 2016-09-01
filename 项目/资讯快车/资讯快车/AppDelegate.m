//
//  AppDelegate.m
//  资讯快车
//
//  Created by qingyun on 16/8/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GuideViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if 0
    // 1. 获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2. 设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [SVProgressHUD showInfoWithStatus:@"未知网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showInfoWithStatus:@"请检查你的网络设置!"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [SVProgressHUD showInfoWithStatus:@"你正在使用手机网络!"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [SVProgressHUD showSuccessWithStatus:@"WIFI已连接"];
                break;
        }
    }];
    // 3. 开始监控
    [manager startMonitoring];
#endif
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *strOldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldVersion"];
    if ([strVersion isEqualToString:strOldVersion]) {
        [self loadMainViewController];
    }else {
        self.window.rootViewController = [[GuideViewController alloc]init];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)loadMainViewController {
    MainViewController *vcMain = [[MainViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vcMain];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
