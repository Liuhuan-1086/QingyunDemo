//
//  navVC.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "NavVC.h"

@interface NavVC ()

@end

@implementation NavVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBar.translucent = NO;
    for (UIViewController *vc in self.viewControllers) {
        vc.edgesForExtendedLayout = UIRectEdgeNone;
        vc.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//第一次调用这个类的时候调用这个方法
+ (void)initialize {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.00 green:0.33 blue:1.00 alpha:1.00]];
    //隐藏底部黑线
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

//重写跳转方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count != 0) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back_32x32_"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        viewController.view.backgroundColor = [UIColor colorWithRed:0.00 green:0.33 blue:1.00 alpha:1.00];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)popAction {
    [self popViewControllerAnimated:YES];
}

@end
