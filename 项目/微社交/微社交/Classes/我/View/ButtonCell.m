//
//  ButtonCell.m
//  微社交
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ButtonCell.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ButtonCell ()

@property (weak, nonatomic) IBOutlet UIButton *logOut;

@end

@implementation ButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.logOut.layer.cornerRadius = 5;
    self.logOut.layer.masksToBounds = YES;
}
- (IBAction)btnLogOut:(UIButton *)sender {
    [AVUser logOut];
    UIStoryboard *story1 = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vcLogin = [story1 instantiateViewControllerWithIdentifier:@"loginNav"];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vcLogin];
}


@end
