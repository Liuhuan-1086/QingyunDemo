//
//  WebViewController.m
//  资讯快车
//
//  Created by qingyun on 16/8/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "WebViewController.h"
#import "BottomView.h"
#import "TopView.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height)];
    web.scrollView.bounces = NO;
    [self.view addSubview:web];
    NSURL *url = [NSURL URLWithString:_url];
    NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",strData);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [web loadHTMLString:strData baseURL:url];
    [web loadRequest:request];
    
    TopView *top = [TopView viewForHeader];
    top.frame = CGRectMake(0, 0, self.view.width, 64);
    top.backgroundColor = [UIColor colorWithRed:0.20 green:0.71 blue:0.92 alpha:1.00];
    [self.view addSubview:top];
    __weak typeof(self) weakSelf = self;
    top.callBack = ^{
        [weakSelf back];
    };
    
    BottomView *bottom = [BottomView viewForHeader];
    bottom.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    bottom.backgroundColor = [UIColor colorWithRed:0.20 green:0.71 blue:0.92 alpha:1.00];
    [self.view addSubview:bottom];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
