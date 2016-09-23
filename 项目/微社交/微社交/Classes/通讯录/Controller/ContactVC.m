//
//  ContactVC.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ContactVC.h"
#import "ContactCell.h"
#import "ContactModel.h"
#import "FindFriendVC.h"
#import <Masonry/Masonry.h>
#import <AVOSCloud/AVOSCloud.h>
#import <HTChineseHandle/pinyin.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ContactVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isFalse;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mArrModels;
@property (nonatomic, copy) NSArray *arrImages;
@property (nonatomic, copy) NSArray *arrkeys;
@property (nonatomic, copy) NSArray *arrAlertItem;
@property (nonatomic, copy) NSDictionary *dictModels;
@property (nonatomic, weak) UILabel *alertLabel;
@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) UILabel *label;

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addAlertItem];
    [self addAlertLabel];
    [self addRightItem];
    [self settingTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.alertView.alpha = 0;
    self.button.selected = NO;
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //加载等待
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    self.hidesBottomBarWhenPushed = NO;
    [self.mArrModels removeAllObjects];
    __weak typeof(self) weakSelf = self;
    AVQuery *query = [AVQuery queryWithClassName:@"Friends"];
    [query whereKey:@"ownId" equalTo:[[AVUser currentUser] objectForKey:@"objectId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [self alertController:nil Error:error];
        } else {
            [SVProgressHUD dismiss];
            if (objects.count != 0) {
                NSLog(@"%ld",objects.count);
                for (NSUInteger index = 0; index < objects.count; index++) {
                    NSArray *arrFriendIds = objects[index][@"friendId"];
                    for (NSString *friendId in arrFriendIds) {
                        NSLog(@"%ld",arrFriendIds.count);
                        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
                        [query whereKey:@"objectId" equalTo:friendId];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (error) {
                                NSLog(@"===============error");
                                [self alertController:@"加载失败..." Error:nil];
                            } else {
                                NSDictionary *dict = @{@"username":objects[0][@"username"],@"imageData":objects[0][@"imageData"]};
                                ContactModel *model = [ContactModel modelWithDictionary:dict];
                                [weakSelf.mArrModels addObject:model];
                                [weakSelf exchangeFromMutableArray:weakSelf.mArrModels];
                                [weakSelf.tableView reloadData];
                                weakSelf.label.text =[NSString stringWithFormat:@"%ld位联系人",weakSelf.mArrModels.count];
                            }
                        }];
                    }
                }
            }
        }
    }];
}

- (void)initData {
    self.title = @"联系人";
    self.arrAlertItem = @[@"添加好友", @"附近的人", @"扫一扫"];
    self.arrImages = @[@"Address_Icon_21x21_",
                       @"ff_IconLocationService_25x25_",
                       @"ff_IconQRCode_25x25_",];
    self.mArrModels = [NSMutableArray array];
}

- (void)settingTableView {
    [self addFooterView];
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 70;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 25;
    self.tableView.sectionIndexColor = [UIColor orangeColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)addFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] init];
    [footer addSubview:label];
    label.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    label.text = [NSString stringWithFormat:@"%ld位联系人", self.mArrModels.count];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.label = label;
    self.tableView.tableFooterView = footer;
}

- (void)addRightItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 26, 26);
    [button setImage:[UIImage imageNamed:@"barbuttonicon_more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.button = button;
    [self rightBarButtonItemWithCustomView:button];
}

- (void)addAlertItem {
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    alertView.alpha = 0;
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(-30);
    }];
    [alertView layoutIfNeeded];
    self.alertView = alertView;
    //选项
    NSInteger count = self.arrAlertItem.count;
    for (NSUInteger index = 0; index < count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.arrAlertItem[index] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.arrImages[index]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateHighlighted];
        if (index == 2) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        }else {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }
        [button setFrame:CGRectMake(0, index * 50, 150, 50)];
        [button setTag:index + 100];
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:button];
    }
}

- (void)clickItem:(UIButton *)button {
    self.alertView.alpha = 0;
    self.button.selected = !self.button.selected;
    NSInteger index = button.tag - 100;
    switch (index) {
        case 0:
        {
            UIViewController *vcSearchFriend = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchFriendVC"];
            [self.navigationController pushViewController:vcSearchFriend animated:YES];
        }
            break;
        case 1:
        {
            UIViewController *vcSousuo = [self.storyboard instantiateViewControllerWithIdentifier:@"FindFriendVC"];
            [self.navigationController pushViewController:vcSousuo animated:YES];
        }
            break;
        case 2:
        {
            UIViewController *vcCode = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeVC"];
            [self.navigationController pushViewController:vcCode animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)moreBtn:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.alpha = 0;
        }];
    }
}

- (void)addAlertLabel {
    UILabel *alertLabel = [[UILabel alloc] init];
    self.alertLabel = alertLabel;
    [self.view addSubview:alertLabel];
    alertLabel.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 - 100);
    alertLabel.bounds = CGRectMake(0,0,80, 80);
    alertLabel.backgroundColor = [UIColor blackColor];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont boldSystemFontOfSize:20];
    alertLabel.alpha = 0;
}

- (void)exchangeFromMutableArray:(NSMutableArray *)mArray
{
    self.dictModels = [mArray sortedArrayUsingFirstLetterByKeypath:@"strUserName"];
    self.arrkeys = [[self.dictModels allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrkeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictModels[self.arrkeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 18)];
    cell.model = self.dictModels[self.arrkeys[indexPath.section]][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.alertView.alpha == 1) {
        __weak typeof(self) vcContact = self;
        [UIView animateWithDuration:0.25 animations:^{
            vcContact.alertView.alpha = 0 ;
        }];
        vcContact.button.selected = NO;
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, 100, 20);
    header.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    UILabel *label = [[UILabel alloc] init];
    [header addSubview:label];
    label.text = self.arrkeys[section];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(4);
        make.bottom.equalTo(header).offset(-4);
        make.leading.mas_equalTo(header).offset(10);
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = [NSMutableArray array];
    for(char section='A';section<='Z';section++)
    {
        [array addObject:[NSString stringWithFormat:@"%c",section]];
    }
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alertView.alpha = 0;
    }];
    self.button.selected = NO;
    [self showLetter:title];
    return [self.arrkeys indexOfObject:title];
}

- (void)showLetter:(NSString *)title {
    [UIView animateWithDuration:0.25 animations:^{
        self.alertLabel.alpha = 0.4;
    }];
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    self.alertLabel.text = title;
    [self performSelector:@selector(cancel) withObject:nil afterDelay:0.3];
}

- (void)cancel{
    [UIView animateWithDuration:0.25 animations:^{
        self.alertLabel.alpha = 0;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.alpha = 0;
    }];
    self.button.selected = NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.alpha = 0;
    }];
    self.button.selected = NO;
}

@end
