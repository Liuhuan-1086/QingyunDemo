//
//  TopView.m
//  资讯快车
//
//  Created by qingyun on 16/8/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "TopView.h"

@implementation TopView

+ (instancetype)viewForHeader {
    return [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:nil options:nil] lastObject];
}

- (IBAction)clickBtn:(id)sender {
    _callBack();
}


@end
