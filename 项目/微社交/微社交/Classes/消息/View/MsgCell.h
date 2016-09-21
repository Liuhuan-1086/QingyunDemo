//
//  MsgCell.h
//  微社交
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MsgModel;

@interface MsgCell : UITableViewCell

@property (nonatomic, strong) MsgModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
