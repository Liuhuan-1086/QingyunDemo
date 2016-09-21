//
//  AddFriendVC.m
//  微社交
//
//  Created by qingyun on 16/9/19.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "AddFriendVC.h"
#import "ContactCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddFriendVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, assign) BOOL isEmail;
@property (nonatomic, copy) NSDictionary *dictData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (nonatomic, copy) void (^blockAddFriend)(NSDictionary *dict);

@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self query];
    [self loadDefaultSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //加载等待
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
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
                            @{@"imageData":object[@"imageData"],
                              @"username":object[@"username"],
                              @"email":object[@"email"],
                          @"emailData":object[@"emailData"]};
                } else {
                    self.isEmail = NO;
                    strongSelf.dictData =
                            @{@"imageData":object[@"imageData"],
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
    if (_blockAddFriend) {
        _blockAddFriend(self.dictData);
    }
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

- (void)dealloc {
    [SVProgressHUD dismiss];
}
@end
