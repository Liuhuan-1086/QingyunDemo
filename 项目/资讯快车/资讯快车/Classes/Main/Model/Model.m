//
//  FirstModel.m
//  资讯快车
//
//  Created by qingyun on 16/8/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (instancetype)modelWithDictionary:(NSDictionary *)dictData {
    Model *model = [[[self class] alloc] init];
    NSInteger count = [dictData[@"votecount"] integerValue] + [dictData[@"replyCount"] integerValue];
    model.strCount = [@(count) stringValue];
    model.strSource = dictData[@"source"];
    model.strDocId = dictData[@"docid"];
    model.strTitle = dictData[@"title"];
    model.strImageUrl = dictData[@"imgsrc"];
    model.strSkipId = dictData[@"skipID"];
    model.strSkipType = dictData[@"skipType"];
    model.strDocUrl = dictData[@"url"];
    model.arrImageUrls = dictData[@"imgextra"];
    return model;
}

@end
