//
//  HomeVC.m
//  Yueba
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "FindFriendVC.h"
#import "SearchVC.h"
#import "AppDelegate.h"
#import "QYLocationManager.h"
#import "UserInfo.h"

@interface FindFriendVC ()

@property (nonatomic, strong)NSArray *nearUser;//找到的周围用户

@end

@implementation FindFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.nearUser) {
        //展示搜索界面
        SearchVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];

        [self presentViewController:vc animated:YES completion:nil];
        
        //雷达的回调
        __weak FindFriendVC *home = self;
        [[QYLocationManager shareLocationManager] setRadarNear:^(NSArray *result){
            home.nearUser = result;
            //更新内容;
            [home uploadInfo];
            //取消展示界面
            [home dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

//更新内容
-(void)uploadInfo{  // 支付 即时通讯 电商
    //获取所有用户的id
    NSArray *userids = [self.nearUser valueForKeyPath:@"userID"];
    
    
}

@end
