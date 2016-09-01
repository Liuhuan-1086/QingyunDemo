//
//  ViewController.m
//  资讯快车
//
//  Created by qingyun on 16/8/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//  Main

#import "MainViewController.h"
#import "WebViewController.h"
#import "NavigationBar.h"
#import "ContentView.h"
#import "MJRefresh.h"
#import "BottomView.h"

@interface MainViewController ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *arrItem;
@property (nonatomic, copy) NSArray *arr_title_id;
@property (nonatomic, copy) NSArray *arr_base_url;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) NavigationBar *navBar;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadArr];
    [self loadNavigationBar];
    [self loadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)loadArr{
    self.arrItem = @[@"头条",@"体育",@"娱乐",@"财经"];
    self.arr_title_id = @[@"T1467284926140",
                          @"T1348649079062",
                          @"T1348648517839",
                          @"T1348648756099"];
}

- (void)loadNavigationBar {
    NavigationBar *navBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    [self.view addSubview:navBar];
    navBar.arrItem = self.arrItem;
    __weak typeof(self) weakSelf = self;
    navBar.callBack = ^(NSInteger index){
        weakSelf.scrollView.contentOffset =CGPointMake(index * screen_width, 0);
    };
    self.navBar = navBar;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    BottomView *bottom = [BottomView viewForHeader];
    bottom.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    bottom.backgroundColor = [UIColor colorWithRed:0.20 green:0.71 blue:0.92 alpha:1.00];
    [self.view addSubview:bottom];
}

- (void)loadScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64)];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    NSInteger count = self.arrItem.count;
    for (NSUInteger index = 0; index < count; index++) {
        ContentView *contentView = [[ContentView alloc] initWithFrame:CGRectMake(index *scrollView.width, 0, scrollView.width, scrollView.height)];
        contentView.tag = index+100;
        contentView.arr_title_id = self.arr_title_id;
        [contentView.tableView.mj_footer beginRefreshing];
        [scrollView addSubview:contentView];
        __weak typeof(self) weakSelf = self;
        contentView.callBack = ^(UIViewController *vcWeb){
            [weakSelf.navigationController pushViewController:vcWeb animated:YES];
        };
    }
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(count * scrollView.width, scrollView.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/screen_width;
    [self.navBar changeButtonAtindex:index];
}

@end
