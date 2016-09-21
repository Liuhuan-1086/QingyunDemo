//
//  MsgModel.m
//  微社交
//
//  Created by qingyun on 16/9/14.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "MsgModel.h"
#import "NSString+Date.h"

@implementation MsgModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        return [[[self class] alloc] initWithDictionary:dict];
    }
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.strUserName = dict[@"username"];
        self.imageData = dict[@"imageData"];
        self.strMessage = dict[@"message"];
        self.strTime = [NSString stringWithDate:dict[@"date"]];
    }
    return self;
}

@end
