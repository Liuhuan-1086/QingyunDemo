//
//  ViewController.m
//  SliderBar
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SliderVC.h"

typedef NS_ENUM(NSUInteger, FrontPosition) {
    kFrontPositionLeft,
    kFrontPositionRight
};

@interface SliderVC ()

/** rightVC的位置 */
@property (nonatomic, assign) FrontPosition position;

/** leftVC距右边的宽度 */
@property (nonatomic, assign) CGFloat rightMargin;

/** 点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/** 滑动手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation SliderVC

- (instancetype)initWithLeftViewController:(UIViewController *)leftVC RightViewController:(UIViewController *)rightVC {
    if (self = [super init]) {
        
        //初始化属性
        _leftVC = leftVC;
        _rightVC = rightVC;
        
        //添加子控制器
        [self addChildViewController:_leftVC];
        [self addChildViewController:_rightVC];
    }
    
    return self;
}

//加载控制器的view
- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //rightVC滑到右边剩余的宽度
    self.rightMargin = 80;
    //rightVC的默认的位置
    self.position = kFrontPositionLeft;
    //操作的手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    //添加子控制器的view
    [self addChildView];
}

- (void)addChildView {
    [self.view addSubview:self.leftVC.view];
    [self.view addSubview:self.rightVC.view];
    
    //view添加手势
    [self.rightVC.view addGestureRecognizer:self.pan];
    [self.rightVC.view addGestureRecognizer:self.tap];
}

//view设置frame后调用的方法调整子视图的位置
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutChildView];
}

//调整子控制器的view.frame
- (void)layoutChildView {
    //leftVC
    self.leftVC.view.frame = self.view.bounds;
    
    //rightVC
    if (self.position == kFrontPositionLeft) {
        self.rightVC.view.frame = self.view.bounds;
    } else {
        CGFloat left = self.view.bounds.size.width - self.rightMargin;
        //偏移
        self.rightVC.view.frame = CGRectOffset(self.view.bounds, left, 0);
    }
}

//点击手势事件
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.position == kFrontPositionRight) {
        self.position = kFrontPositionLeft;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutChildView];
    }];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        //相对于该view拖拽了多少
        CGPoint point = [pan translationInView:self.view];
        //计算出起始位置
        if (self.position == kFrontPositionLeft) {
            self.rightVC.view.frame = CGRectOffset(self.view.bounds, point.x, 0);
        } else {
            CGFloat leftMargin = self.view.bounds.size.width - self.rightMargin;
            //右边的起始位置
            CGRect frame = CGRectOffset(self.view.bounds, leftMargin, 0);
            self.rightVC.view.frame = CGRectOffset(frame, point.x, 0);
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded){
        CGFloat leftMargin = self.view.bounds.size.width - self.rightMargin;
        CGFloat center = leftMargin * 0.5;
        if (self.rightVC.view.frame.origin.x > center) {
            self.position = kFrontPositionRight;
        } else {
            self.position = kFrontPositionLeft;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutChildView];
        }];
        
    } else {
    
    }
}

@end
