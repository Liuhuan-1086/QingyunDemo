//
//  FindFriendVC.m
//  微社交
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "SearchFriendVC.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SearchFriendVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mArrData;

@end

@implementation SearchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addObserve];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)initData {
    self.title = @"查找好友";
    self.tfSearch.delegate = self;
    self.mArrData = [NSMutableArray array];
    self.tableView.rowHeight = 60;
    self.tfSearch.returnKeyType = UIReturnKeySearch;
    self.tableView.separatorStyle = self.mArrData.count == 0 ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;
    self.tableView.hidden = YES;
}

//注册监听
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isEditing:) name:UITextFieldTextDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

//加载等待
- (void)reloadData:(NSString *)strData {
    //加载等待
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //请求数据
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:strData];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            [SVProgressHUD dismiss];
            NSLog(@"%ld",objects.count);
            if (objects.count == 0) {
                [self alertController:@"您搜索的用户不存在" Error:nil];
                return;
            }
            [self.mArrData removeAllObjects];
            for (AVObject *object in objects) {
                if (![object[@"objectId"] isEqualToString:
                      [[AVUser currentUser] objectForKey:@"objectId"]]) {
                    NSString *username = object[@"username"];
                    NSRange range = [username rangeOfString:strData];
                    NSMutableAttributedString *mAttriString = [[NSMutableAttributedString alloc] initWithString:username];
                    [mAttriString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(0, username.length)];
                    [mAttriString setAttributes:@{NSForegroundColorAttributeName:[UIColor cyanColor],NSFontAttributeName:[UIFont systemFontOfSize:25]} range:range];
                    NSDictionary *dictData = @{@"imageData":object[@"imageData"],@"ausername":mAttriString};
                    ContactModel *model = [ContactModel modelWithDictionary:dictData];
                    [weakSelf.mArrData addObject:model];
                    [weakSelf.tableView reloadData];
                }
            }
        }
    }];
}

- (void)beginEdit:(NSNotification *)nito {
    NSLog(@"%s",__func__);
    self.tableView.hidden = NO;
    self.tfSearch.text = nil;
}

- (void)isEditing:(NSNotification *)nito {
    NSLog(@"%s",__func__);
}

- (void)endEdit:(NSNotification *)nito {
    NSLog(@"%s",__func__);
    self.tableView.hidden = NO;
    if (self.tfSearch.text.length == 0) {
        [self alertController:@"请输入要搜索的用户名"
                        Error:nil];
        return;
    }
    NSString *strData = self.tfSearch.text;
    [self reloadData:strData];
}

- (IBAction)btnSearch:(UIButton *)sender {
    [self.tfSearch resignFirstResponder];
    [self.tfSearch endEditing:YES];
    if (self.tfSearch.text.length == 0) {
        [self alertController:@"请输入要搜索的用户名"
                        Error:nil];
        return;
    }
    NSString *strData = self.tfSearch.text;
    [self reloadData:strData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.tfSearch.text.length == 0) {
        [self alertController:@"请输入要搜索的用户名"
                        Error:nil];
        return nil;
    }
    NSString *strData = textField.text;
    [self reloadData:strData];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [ContactCell cellWithTableView:tableView];
    cell.model = self.mArrData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD dismiss];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    UIViewController *vcAddFriend = [story instantiateViewControllerWithIdentifier:@"AddFriendVC"];
    [vcAddFriend setValue:[self.mArrData[indexPath.row] mAttrStrUserName].string forKey:@"strUserName"];
    [self.navigationController pushViewController:vcAddFriend animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
