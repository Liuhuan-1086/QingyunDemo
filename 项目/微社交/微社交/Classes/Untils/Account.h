//
//  Account.h
//  微社交
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Account : NSObject<NSCoding>

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *userName;

//是否登录
- (BOOL)islogin;

- (BOOL)logOut;

+ (instancetype) shareAccount;

- (void)save:(NSDictionary *)info;

@end
