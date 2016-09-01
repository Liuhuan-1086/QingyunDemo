//
//  HttpRequestManager.h
//  资讯快车
//
//  Created by qingyun on 16/8/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestManager : NSObject
/** 单例 */
+ (instancetype) shareHttpRequestManager;
/** ListData */
- (void)request_list_data_title_id:(NSString *)title_id
                              page:(NSInteger)page
                           success:(void(^)(id responseData))success
                           failure:(void(^)(NSError *error))failure;

@end
