//
//  ChartCell.h
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//  聊天界面的cell

#import <UIKit/UIKit.h>

@interface ChartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;

@end
