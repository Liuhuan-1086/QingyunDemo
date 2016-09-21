//
//  MsgVC.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "MsgVC.h"
#import "MsgCell.h"
#import "MsgModel.h"
#import "AppDelegate.h"

@interface MsgVC ()<UITableViewDelegate, UITableViewDataSource, AVIMClientDelegate>

@property (nonatomic, weak) UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mArrReceiveMessages;

@end

@implementation MsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clientSetting];
    [self loadDefaultSetting];
}

- (void)clientSetting {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.client.delegate = self;
}

- (void) loadDefaultSetting {
    [self rightBtn];
    [self initTableView];
}

- (void)initTableView {
    self.title = @"消息";
    self.tableView.rowHeight = 100;
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //分割线
    if (self.mArrReceiveMessages.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //无消息
        [self noneMessage];
    } else {
        self.label.hidden = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void) rightBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"spot_1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self rightBarButtonItemWithCustomView:button];
}

- (void)noneMessage {
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
    label.bounds = CGRectMake(0, 0, 200, 50);
    label.text = @"没有新的消息";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view insertSubview:label aboveSubview:self.tableView];
    self.label = label;
}

- (void)btnSearch:(UIButton *)button {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    UIViewController *vcAddFriend = [story instantiateViewControllerWithIdentifier:@"SearchFriendVC"];
    [self.navigationController pushViewController:vcAddFriend animated:YES];
}

#pragma mark - lazy load mArrReceiveMessages

- (NSMutableArray *)mArrReceiveMessages {
    if (!_mArrReceiveMessages) {
        _mArrReceiveMessages = [NSMutableArray array];
    }
    return _mArrReceiveMessages;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrReceiveMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [MsgCell cellWithTableView:tableView];
    cell.model = self.mArrReceiveMessages[indexPath.row];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - client delegate

/*!
 收到未读通知。在该终端上线的时候，服务器会将对话的未读数发送过来。未读数可通过 -[AVIMConversation markAsReadInBackground] 清零，服务端不会自动清零。
 @param conversation 所属会话。
 @param unread 未读消息数量。
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    NSLog(@"%s",__func__);
    self.navigationController.tabBarItem.badgeValue = [@(unread) stringValue];
}

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    NSLog(@"%s", __func__);
    self.label.hidden = YES;
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:conversation.clientId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *dict = @{@"imageData":objects[0][@"imageData"] ,@"username":objects[0][@"username"],@"message":message.content,@"date":conversation.createAt};
           MsgModel *model = [MsgModel modelWithDictionary:dict];
            [self.mArrReceiveMessages addObject:model];
            [self.tableView reloadData];
        }
    }];
}

@end
