//
//  NavigationBar.m
//  资讯快车
//
//  Created by qingyun on 16/8/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NavigationBar.h"

#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

@interface NavigationBar ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *slider;
@property (nonatomic, copy) NSArray *arrBtn;

@end

@implementation NavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void) initUI{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.20 green:0.71 blue:0.92 alpha:1.00];
    [self addSubview:view];
    self.view = view;
    UIView *slider = [[UIView alloc] init];
    [self addSubview:slider];
    self.slider = slider;
    self.slider.backgroundColor = [UIColor whiteColor];
}

- (void)setArrItem:(NSArray *)arrItem {
    _arrItem = [arrItem copy];
    NSUInteger count = arrItem.count;
    NSMutableArray *mArrBtn = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arrItem[index] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.75 green:0.91 blue:0.98 alpha:1.00] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.97 green:0.98 blue:0.99 alpha:1.00] forState:UIControlStateDisabled];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor colorWithRed:0.20 green:0.71 blue:0.92 alpha:1.00]];
        btn.tag = index + 100;
        [self.view addSubview:btn];
        [mArrBtn addObject:btn];
    }
    self.arrBtn = mArrBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.arrBtn.count;
    self.view.frame = CGRectMake(0, 0, screen_width, 64);
    self.slider.frame = CGRectMake(0, 62, screen_width/count, 2);
    for (UIButton *btn in self.arrBtn) {
        NSInteger index = [self.arrBtn indexOfObject:btn];
        [btn setFrame:CGRectMake(index * screen_width/count, 20, screen_width/count, 44)];
    }
}

- (void)clickBtn:(UIButton *)btn {
    for (UIButton *btn in self.arrBtn) {
        btn.enabled = YES;
    }
    btn.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.slider.frame = CGRectMake(btn.x, weakSelf.height - 2, btn.width, 2);
    }];
    NSInteger index = btn.tag - 100;
    _callBack(index);
}

- (void)changeButtonAtindex:(NSInteger)currentIndex {
    NSInteger count = self.arrBtn.count;
    for (NSUInteger index = 0; index < count; index++) {
        UIButton *button = self.arrBtn[index];
        if (button.tag == currentIndex+100) {
            [self clickBtn:button];
            break;
        }
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    BOOL isTure;
    if (isTure == YES) {
        for (UIButton *btn in self.arrBtn) {
            if (btn.tag == 100) {
                [self clickBtn:btn];
                break;
            }
        }
        isTure = NO;
    }
}

@end
