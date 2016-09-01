//
//  BottomView.m
//  资讯快车
//
//  Created by qingyun on 16/8/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView
{
    __weak IBOutlet UIImageView *_imgView;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    _imgView.layer.cornerRadius = 5;
    _imgView.clipsToBounds = YES;
}

+ (instancetype)viewForHeader {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:nil options:nil] lastObject];
}

@end
