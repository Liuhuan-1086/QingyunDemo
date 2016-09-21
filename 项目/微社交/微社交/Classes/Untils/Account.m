//
//  Account.m
//  微社交
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "Account.h"
#import "Common.h"
#import <AVUser.h>

#define kAccountFile @"AccountFile"

@interface Account ()

@end

@implementation Account

//是否登录
- (BOOL)islogin {
    if (self.userName) {
        return YES;
    }else {
        return NO;
    }
}

+ (instancetype)shareAccount {
    static Account *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //归档路径
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:kAccountFile];
        NSLog(@"%@",filePath);
        //解档
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!account) {
            //如果解档失败
            account = [[Account alloc] init];
        }
    });
    return account;
}

- (void)save:(NSDictionary *)info {
    self.userName = info[@"username"];
    self.objectId = info[@"objectId"];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:kAccountFile];
    
    [NSKeyedArchiver  archiveRootObject:self toFile:filePath];
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userName forKey:@"username"];
    [aCoder encodeObject:self.objectId forKey:@"objectId"];
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"username"];
        self.objectId = [aDecoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

@end
