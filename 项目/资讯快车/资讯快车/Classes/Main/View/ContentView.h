//
//  ContentView.h
//  资讯快车
//
//  Created by qingyun on 16/8/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentView : UIView

@property (nonatomic, copy) void(^callBack)(UIViewController *vcWeb);
@property (nonatomic, copy) NSArray *arr_title_id;
@property (nonatomic, weak) UITableView *tableView;
- (void) base_url_title_id:(NSString *)title_id;

@end
