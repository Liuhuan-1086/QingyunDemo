//
//  MainVC.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "MainVC.h"
#import "NavVC.h"

@interface MainVC ()

@property (nonatomic, copy) NSArray *arrTitle;
@property (nonatomic, copy) NSArray *arrImage;
@property (nonatomic, copy) NSArray *arrController;
@property (nonatomic, copy) NSArray *arrSelectImage;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    UIStoryboard *story1 = [UIStoryboard storyboardWithName:@"Msg" bundle:nil];
    UIStoryboard *story2 = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    UIStoryboard *story3 = [UIStoryboard storyboardWithName:@"Find" bundle:nil];
    UIStoryboard *story4 = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UIViewController *vcMsg = [story1 instantiateViewControllerWithIdentifier:@"MsgVC"];
    UIViewController *vcContact = [story2 instantiateViewControllerWithIdentifier:@"ContactVC"];
    UIViewController *vcFind = [story3 instantiateViewControllerWithIdentifier:@"FindVC"];
    UIViewController *vcMine = [story4 instantiateViewControllerWithIdentifier:@"MineVC"];

    self.arrTitle = @[@"消息",@"通讯录",@"发现",@"我"];
    self.arrImage = @[@"newsfeed_26x26_",
                      @"home_26x26_",
                      @"explore_26x26_",
                      @"profile_26x26_"];
    self.arrSelectImage = @[@"newsfeedPress_26x26_",
                            @"homePress_26x26_",
                            @"explorePress_26x26_",
                            @"profilePress_26x26_"];

    self.arrController = @[vcMsg,vcContact,vcFind,vcMine];
    NSUInteger count = self.arrTitle.count;
    for (NSUInteger index = 0; index < count; index++) {
        [self Controller:self.arrController[index] Title:self.arrTitle[index] Image:self.arrImage[index] SelectImage:self.arrSelectImage[index]];
    }
    //去掉tabbar顶部导航条
    [self.tabBar setClipsToBounds:YES];
    //设置字体颜色
    self.tabBar.tintColor = [UIColor colorWithRed:0.00 green:0.33 blue:1.00 alpha:1.00];
}

- (void)Controller:(UIViewController *)vc Title:(NSString *)title Image:(NSString *)imageName SelectImage:(NSString *)selectImage{
    vc.tabBarItem.title = title;
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    NavVC *vcNav = [[NavVC alloc] initWithRootViewController:vc];
    [self addChildViewController:vcNav];
}

@end
