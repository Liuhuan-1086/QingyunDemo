//
//  HttpRequest.h
//  资讯快车
//
//  Created by qingyun on 16/8/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+ (instancetype)shareHttpRequest;
- (void)Get:(NSString *)url Param:(NSDictionary *)dictData Success:(void(^)(id responseData))success Failure:(void(^)(NSError *error))failure;
- (void)Post:(NSString *)url Param:(NSDictionary *)dictData Success:(void(^)(id responseData))success Failure:(void(^)(NSError *error))failure;

@end
