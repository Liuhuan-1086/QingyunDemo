//
//  ContentVC.m
//  微社交
//
//  Created by qingyun on 16/9/22.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ContentVC.h"

@interface ContentVC ()

@end

@implementation ContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:self.strCode];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
