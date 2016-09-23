//
//  AddFriendVC.m
//  微社交
//
//  Created by qingyun on 16/9/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "AddFriendVC.h"
#import "ContactCell.h"
#import "ContactVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddFriendVC ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isCreated;
}
@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, assign) BOOL isEmail;
@property (nonatomic, copy) NSDictionary *dictData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;

@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self query];
    [self loadDefaultSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isCreated) {
        //加载等待
        [SVProgressHUD showWithStatus:@"加载中..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        _isCreated = YES;
    }
    
    self.btnAddFriend.alpha = 0;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadDefaultSetting {
    self.title = @"好友信息";
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) query {
    //请求数据
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.strUserName];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"%ld", (unsigned long)objects.count);
            [SVProgressHUD dismiss];
            __strong typeof(weakSelf) strongSelf = self;
            strongSelf.btnAddFriend.alpha = 1;
            for (AVObject *object in objects) {
                if (object[@"email"]) {
                    self.isEmail = YES;
                    strongSelf.dictData =
                            @{@"friendId":object[@"objectId"],
                              @"imageData":object[@"imageData"],
                              @"username":object[@"username"],
                              @"email":object[@"email"],
                          @"emailData":object[@"emailData"]};
                } else {
                    self.isEmail = NO;
                    strongSelf.dictData =
                            @{@"friendId":object[@"objectId"],
                              @"imageData":object[@"imageData"],
                              @"username":object[@"username"],
            @"mobilePhoneNumber":object[@"mobilePhoneNumber"],
                          @"phoneData":object[@"phoneData"]};
                }
                [strongSelf.tableView reloadData];
            }
        }
    }];
}

- (IBAction)addFriendBtn:(UIButton *)sender {
    //查询是否存在
    AVQuery *query = [AVQuery queryWithClassName:@"Friends"];
    [query whereKey:@"ownId" equalTo:[[AVUser currentUser] objectForKey:@"objectId"]];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"==================error");
        } else {
            if (objects.count != 0 && [objects[0][@"friendId"] containsObject:weakSelf.dictData[@"friendId"]]) {
                //跳转
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            } else {
                //保存到Friends表中
                AVObject *friend = [[AVObject alloc] initWithClassName:@"Friends"];
                //保存用户id
                [friend setObject:[[AVUser currentUser] objectForKey:@"objectId"] forKey:@"ownId"];
                //保存朋友的id到数组中
                [friend addObject:self.dictData[@"friendId"] forKey:@"friendId"];
                [friend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"==================error");
                    } else {
                        //跳转
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        NSLog(@"==================succeeded");
                    }
                }];
            }
            NSLog(@"%@", objects);
        }
    }];
   

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [ContactCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        [cell setValue:[UIImage imageWithData:self.dictData[@"imageData"]] forKeyPath:@"imgView.image"];
        [cell setValue:self.dictData[@"username"] forKeyPath:@"lbName.text"];
    } else {
        if (self.isEmail) {
            [cell setValue:[UIImage imageWithData:self.dictData[@"emailData"]] forKeyPath:@"imgView.image"];
            [cell setValue:self.dictData[@"email"] forKeyPath:@"lbName.text"];
        } else if(!self.isEmail){
            [cell setValue:[UIImage imageWithData:self.dictData[@"phoneData"]] forKeyPath:@"imgView.image"];
            [cell setValue:self.dictData[@"mobilePhoneNumber"] forKeyPath:@"lbName.text"];
        }else {
        
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.view = nil;
}

@end
