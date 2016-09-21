//
//  ContactCell.h
//  微社交
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactModel;

@interface ContactCell : UITableViewCell

@property (nonatomic, strong) ContactModel *model;

+ (instancetype) cellWithTableView:(UITableView *)tableView;

@end
