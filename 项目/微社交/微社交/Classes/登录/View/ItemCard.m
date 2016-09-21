//
//  ItemCard.m
//  微社交
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ItemCard.h"
#import "Masonry.h"

@interface ItemCard ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ItemCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
        [self addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(self).offset(20);
            make.trailing.bottom.mas_equalTo(self).offset(-20);
        }];
    }
    return self;
}

#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"手机找回";
    } else {
        cell.textLabel.text = @"邮箱找回";
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = nil;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        vc = [story instantiateViewControllerWithIdentifier:@"PhoneVC"];
    } else {
        vc = [story instantiateViewControllerWithIdentifier:@"MailVC"];
    }
    if ([self.delegate respondsToSelector:@selector(pushToViewController:)]) {
        [self.delegate pushToViewController:vc];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.text = @"找回方式";
    label.font = [UIFont systemFontOfSize:24 weight:3];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView.bounds.size.height / 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height / 3;
}

@end
