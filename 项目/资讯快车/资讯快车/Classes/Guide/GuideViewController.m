//
//  GuideViewController.m
//  程序部落
//
//  Created by qingyun on 16/8/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "GuideViewController.h"
#import "MoreViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"

@interface  GuideViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, copy) NSArray *arrImageNames;
@property (nonatomic, copy) NSArray *arrControllers;
@property (nonatomic, strong) UIPageViewController *vcPage;

@end

@implementation GuideViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void) loadDefaultSetting {
    self.vcPage.delegate = self;
    self.vcPage.dataSource = self;
    [self.vcPage setViewControllers:@[self.arrControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.vcPage];
    [self.view addSubview:self.vcPage.view];
}

- (UIPageViewController *)vcPage {
    if (_vcPage == nil) {
        _vcPage = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    }
    return _vcPage;
}

- (NSArray *)arrImageNames {
    if (_arrImageNames == nil) {
        NSUInteger count = 4;
        NSMutableArray *arrMTemp = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger index = 0; index < count; index++) {
            NSString *name = [NSString stringWithFormat:@"img_%02ld.jpeg",index+1];
            [arrMTemp addObject:name];
        }
        _arrImageNames = [arrMTemp copy];
    }
    return _arrImageNames;
}

- (NSArray *)arrControllers {
    if (_arrControllers == nil) {
        NSUInteger count = self.arrImageNames.count;
        NSMutableArray *arrMTemp = [NSMutableArray arrayWithCapacity:count];
        for (NSUInteger index = 0; index < count; index++) {
            MoreViewController *vcMore = [[MoreViewController alloc] init];
            [self addImageView:vcMore atIndex:index];
            [arrMTemp addObject:vcMore];
            if (index == count - 1) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [vcMore.view addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(vcMore.view).offset(screen_width * 0.5 - 100);
                    make.trailing.equalTo(vcMore.view).offset(-(screen_width * 0.5 - 100));
                    make.bottom.equalTo(vcMore.view).offset(-50);
                    make.height.equalTo(@(40));
                }];
                [button setTitle:@"立即体验" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:0.93 green:0.65 blue:0.62 alpha:1.00] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:18];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
                button.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.65 blue:0.62 alpha:1.00] CGColor];
                button.layer.borderWidth = 1;
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                [button addTarget:self action:@selector(TapAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        _arrControllers = [arrMTemp copy];
    }
    return _arrControllers;
}

- (void)TapAction {
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:strVersion forKey:@"oldVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate loadMainViewController];
}

- (void)addImageView:(MoreViewController *)vcMore atIndex:(NSInteger)index{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:self.arrImageNames[index]];
    [vcMore.view addSubview:imageView];
}

/** 展示前一个Controller */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger count = self.arrControllers.count;
    for (NSUInteger index = 0; index < count; index++) {
        UIViewController *vcTemp = self.arrControllers[index];
        if (vcTemp == viewController) {
            NSInteger currentIndex = index - 1;
            if (currentIndex >= 0) {
                return self.arrControllers[currentIndex];
            }else {
                return nil;
            }
        }
    }
    return nil;
}

/** 展示后一个Controller */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger count = self.arrControllers.count;
    for (NSUInteger index = 0; index < count; index++) {
        
        UIViewController *vcTemp = self.arrControllers[index];
        if (vcTemp == viewController) {
            NSUInteger currentIndex = index + 1;
            if (currentIndex < count) {
                return self.arrControllers[currentIndex];
            }else {
                return nil;
            }
        }
    }
    return nil;
}

@end
