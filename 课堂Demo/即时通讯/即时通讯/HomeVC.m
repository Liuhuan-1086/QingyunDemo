//
//  HomeVC.m
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HomeVC.h"
#import "ChartVC.h"
#import "AVOSCloud/AVOSCloud.h"

@interface HomeVC ()
{
    __weak HomeVC *_weakVC;
}
@property (nonatomic, copy) NSString *strUserName;
@property (nonatomic, copy) NSArray *arrFriends;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取登录之后保存的用户名
    self.strUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    _weakVC = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //查询好友列表
    AVQuery *query = [AVQuery queryWithClassName:@"Friend"];
    //设置查询条件
    [query whereKey:@"myname" equalTo:self.strUserName];
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        _weakVC.arrFriends = objects;
        [_weakVC.tableView reloadData];
    }];
}

#pragma mark - table view delegate datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.arrFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AVObject *friend = self.arrFriends[indexPath.row];
    cell.textLabel.text = friend[@"friendname"];
    return cell;
}

#pragma mark - navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //区分不同的跳转
    if ([segue.identifier isEqualToString:@"chart"]) {
        //找到所在的行
        UITableViewCell *cell = sender;
        //传递一个cell,找到位置
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        //获取cell对应的数据
        AVObject *friend = self.arrFriends[indexPath.row];
        //跳转、传值
        ChartVC *vc = segue.destinationViewController;
        vc.strFriendName = friend[@"friendname"];
    }
}

@end
