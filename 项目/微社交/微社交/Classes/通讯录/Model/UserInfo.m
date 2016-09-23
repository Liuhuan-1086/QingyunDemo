//
//  UserInfo.m
//  Yueba
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(instancetype)initWithDict:(NSDictionary *)info{
    self = [super init];
    if (self) {
        self.gender = info[@"gender"];
        self.userID = [info[@"userId"] stringValue];
        self.name = info[@"name"];
    }
    return self;
}

@end
