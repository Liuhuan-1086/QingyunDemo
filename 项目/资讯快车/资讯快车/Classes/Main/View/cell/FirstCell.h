//
//  FirstCell.h
//  资讯快车
//
//  Created by qingyun on 16/8/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface FirstCell : UITableViewCell

@property (nonatomic, strong) Model *model;

+ (instancetype) cellWithTableView:(UITableView *)tableView;

@end
