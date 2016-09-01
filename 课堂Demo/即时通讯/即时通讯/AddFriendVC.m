//
//  AddFriendVC.m
//  即时通讯
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AddFriendVC.h"
#import "AVOSCloud/AVOSCloud.h"

@interface AddFriendVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfFriendName;

@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)addFriend:(id)sender {
    if (self.tfFriendName.text == nil) {
        NSLog(@"friendName nil");
        return;
    }
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //向服务器中的Friend表中添加一条记录
    AVObject *friend = [AVObject objectWithClassName:@"Friend"];
    //添加字段
    [friend setObject:username forKey:@"myname"];
    [friend setObject:self.tfFriendName.text forKey:@"friendname"];
    [friend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"保存成功");
        }else {
            NSLog(@"%@",error);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
