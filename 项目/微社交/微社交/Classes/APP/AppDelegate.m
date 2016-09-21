//
//  AppDelegate.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "Account.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)changetoHome {
    MainVC *vcMain = [[MainVC alloc] init];
    self.window.rootViewController = vcMain;
    //初始化聊天的client
    self.client = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].objectId];
    
    // Tom 打开 client
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"client open success");
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"lY3TjxBFuqMvPz9v4m592fsO-gzGzoHsz" clientKey:@"Cho9QEq8PckzsXvLFpLL9j43"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:0.00 green:0.33 blue:1.00 alpha:1.00];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *rootVC = [story instantiateViewControllerWithIdentifier:@"loginNav"];
    if ([AVUser currentUser]) {
        [self changetoHome];
    } else {
        self.window.rootViewController = rootVC;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
