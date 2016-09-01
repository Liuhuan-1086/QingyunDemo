//
//  Model.h
//  资讯快车
//
//  Created by qingyun on 16/8/7.
//  Copyright © 2016年 qingyun. All rights reserved.

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, copy) NSString *strImageUrl;
@property (nonatomic, copy) NSString *strTitle;
@property (nonatomic, copy) NSString *strSkipType;
@property (nonatomic, copy) NSString *strSkipId;
@property (nonatomic, copy) NSString *strSource;
@property (nonatomic, copy) NSString *strCount;
@property (nonatomic, copy) NSString *strDocId;
@property (nonatomic, copy) NSString *strDocUrl;
@property (nonatomic, copy) NSArray *arrImageUrls;
+ (instancetype) modelWithDictionary:(NSDictionary *)dictData;

@end
