//
//  ChartVC.m
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChartVC.h"
#import "ChartCell.h"
#import "AppDelegate.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface ChartVC ()<UITableViewDelegate, UITableViewDataSource, AVIMClientDelegate>

@property (nonatomic, copy) NSString *strUserName;
@property (nonatomic, strong) NSMutableArray *mArrMessages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *tfMessage;
@property (nonatomic, strong) AVIMConversation *conversation;

@end

@implementation ChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取用户Id
    self.strUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //创建会话对象
    [self createConversation];
    //初始化数组
    self.mArrMessages = [NSMutableArray array];
    //数据源
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //自适应高度
    self.tableView.rowHeight = 50;
    //分割线
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)createConversation {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSString *conName = [NSString stringWithFormat:@"%@:%@",self.strUserName,self.strFriendName];
    //创建会话
    app.client.delegate = self;
    __weak typeof(self) weakVC = self;
    [app.client createConversationWithName:conName//会话名字
                                 clientIds:@[self.strFriendName]//与谁会话
                                attributes:nil //自定义属性
                                   options:AVIMConversationOptionUnique //可选参数
                                  callback:^(AVIMConversation *conversation, NSError *error) {
                                      if (!error) {
                                          weakVC.conversation = conversation;
                                      }else {
                                          NSLog(@"%@",error);
                                      }
    }];
}

//发送消息
- (IBAction)sendMessageBtn:(id)sender {
    if (self.tfMessage.text == nil) {
        return;
    }
    //消息对象
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.tfMessage.text attributes:nil];
    //会话对象
    __weak typeof(self) weakVC = self;
    [self.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送成功");
        }else {
            NSLog(@"发送失败");
        }
    }];
    weakVC.tfMessage.text = nil;
    [weakVC.mArrMessages addObject:message];
    //刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakVC.tableView reloadData];
    });
}

#pragma mark - client delegate

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    [self.mArrMessages addObject:message];
    [self.tableView reloadData];
}

#pragma mark - table view datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrMessages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMTextMessage *message = self.mArrMessages[indexPath.row];
    //判断是收到的消息还是发送的消息
    ChartCell *cell = nil;
    if ([message.clientId isEqualToString:self.strUserName]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
    }
    //绑定内容
    cell.lbUserName.text = message.clientId;
    NSLog(@"%@",message.clientId);
    cell.lbMessage.text = message.text;
    //分割线
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

@end
