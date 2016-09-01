//
//  NavigationBar.h
//  资讯快车
//
//  Created by qingyun on 16/8/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//  NavigationBar

#import <UIKit/UIKit.h>

@interface NavigationBar : UIView

@property (nonatomic, copy) NSArray *arrItem;
@property (nonatomic, copy) void(^callBack)(NSInteger index);

- (void)changeButtonAtindex:(NSInteger)index;

@end
