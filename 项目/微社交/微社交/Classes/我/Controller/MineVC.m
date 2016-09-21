//
//  MineVC.m
//  微社交
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "MineVC.h"
#import "Common.h"
#import "Account.h"
#import "ButtonCell.h"
#import <AVOSCloud/AVOSCloud.h>

#define kPictureHeight 200

@interface MineVC ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isButton;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, copy) NSArray *arrData;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isButton = NO;
    self.navigationItem.title = @"我的";
    self.arrData = @[@"我的收藏", @"我的文章", @"退出登录"];
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    //从照片库中获取图片
    self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //下面两个属性的设置是与translucent为NO, 坐标变化的效果一样
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
}

#pragma mark - table view lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:@"ButtonCell"];
        _tableView.showsVerticalScrollIndicator = NO;
        
        //添加表头视图, 在表头视图上添加ImageView
        self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kPictureHeight)];
        _pictureImageView = [[UIImageView alloc] initWithFrame:_header.bounds];
        _pictureImageView.image = [UIImage imageNamed:@"bg_picture"];
        //这个属性决定了子视图的显示
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        // 这个属性决定了子视图的显示范围 取值为YES时，剪裁超出父视图范围的子视图部分.这里就是裁剪了_pictureImageView超出_header范围的部分.
        _pictureImageView.clipsToBounds = YES;
        [_header addSubview:_pictureImageView];
        //头像
        _headImageView = [[UIImageView alloc] init];
        _headImageView.bounds = CGRectMake(0, 0, 80, 80);
        _headImageView.center = CGPointMake(_pictureImageView.center.x, _pictureImageView.center.y + 10);
        if ([[AVUser currentUser] objectForKey:@"imageData"])
        {
            _headImageView.image = [UIImage imageWithData:[[AVUser currentUser] objectForKey:@"imageData"]];
        }
        _headImageView.layer.cornerRadius = 40;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImage:)];
        [_headImageView addGestureRecognizer:tap];
        [_header addSubview:_headImageView];
        //用户名
        self.username = [[UILabel alloc] init];
        _username.center = CGPointMake(_pictureImageView.center.x, CGRectGetMaxY(_headImageView.frame) + 15);
        _username.bounds = CGRectMake(0, 0, 100, 40);
        _username.textColor = [UIColor lightGrayColor];
        _username.textAlignment = NSTextAlignmentCenter;
        _username.text = [AVUser currentUser].username;
        _username.font = [UIFont systemFontOfSize:22];
        [_header addSubview:_username];
        _tableView.tableHeaderView = _header;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)clickHeadImage:(UITapGestureRecognizer *)tap {
    NSLog(@"%s", __func__);
    [self.navigationController presentViewController:self.pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    [[AVUser currentUser] setObject:UIImagePNGRepresentation(image) forKey:@"imageData"];
    [[AVUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else {
            NSLog(@"succeed");
        }
    }];
    self.headImageView.image = image;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    self.isButton = indexPath.row == self.arrData.count - 1 ? YES : NO;
    if (_isButton) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = self.arrData[indexPath.row];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20 weight:0.1];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.arrData.count - 1 ? 100 : 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        CGFloat totalOffset = kPictureHeight - offset;
        CGFloat scale = totalOffset / kPictureHeight;
        CGFloat width = self.view.bounds.size.width * scale;
        self.pictureImageView.frame = CGRectMake(-((width - self.view.bounds.size.width)/2), offset, width, totalOffset);
        self.headImageView.bounds = CGRectMake(0, 0, 80 * scale, 80 * scale);
        self.headImageView.layer.cornerRadius = 40 * scale;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.center = self.pictureImageView.center;
        _username.center = CGPointMake(_pictureImageView.center.x, CGRectGetMaxY(_headImageView.frame) + 20 *scale);
        _username.bounds = CGRectMake(0, 0, 100 * scale, 40 * scale);
        _username.font = [UIFont systemFontOfSize:22 * scale];
    }
}

@end
