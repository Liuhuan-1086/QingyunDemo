//
//  TopView.h
//  资讯快车
//
//  Created by qingyun on 16/8/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView

@property (nonatomic, copy) void(^callBack)();

+ (instancetype) viewForHeader;

@end
