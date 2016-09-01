//
//  ViewController.h
//  SliderBar
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

//侧滑框架
#import <UIKit/UIKit.h>

@interface SliderVC : UIViewController

/*左边的控制器*/
@property (nonatomic, strong) UIViewController *leftVC;
/** 右边的控制器 */
@property (nonatomic, strong) UIViewController *rightVC;
/** 初始化方法 */
- (instancetype)initWithLeftViewController:(UIViewController *)leftVC RightViewController:(UIViewController *)rightVC;

@end

