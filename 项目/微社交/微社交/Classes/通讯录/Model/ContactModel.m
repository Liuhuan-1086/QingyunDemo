//
//  ContactModel.m
//  微社交
//
//  Created by qingyun on 16/9/18.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

+(instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if (self = [super init]) {
            self.imageData = dict[@"imageData"];
            self.strUserName = dict[@"username"];
            self.mAttrStrUserName = dict[@"ausername"];
        }
    }
    return self;
}

@end
