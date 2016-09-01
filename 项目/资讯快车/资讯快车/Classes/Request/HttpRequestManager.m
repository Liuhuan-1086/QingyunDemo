//
//  HttpRequestManager.m
//  资讯快车
//
//  Created by qingyun on 16/8/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HttpRequestManager.h"
#import "HttpRequest.h"
#import "Model.h"

@interface HttpRequestManager ()

@end

@implementation HttpRequestManager

//线程安全的方式创建单例
+ (instancetype)shareHttpRequestManager {
    static HttpRequestManager *httpRequestManager;
    static dispatch_once_t onceHttpRequestManager;
    __weak typeof(self) weakSelf = self;
    dispatch_once(&onceHttpRequestManager, ^{
        httpRequestManager = [[[weakSelf class] alloc] init];
    });
    return httpRequestManager;
}

- (void)request_list_data_title_id:(NSString *)title_id page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [BaseUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%ld-20.html",title_id,(long)page]];
    
    [[HttpRequest shareHttpRequest] Get:url Param:nil Success:^(id responseData) {
        NSArray *arrData = responseData[title_id];
        NSUInteger count = arrData.count;
        NSMutableArray *mArrModel = [NSMutableArray arrayWithCapacity:count];
        for (NSUInteger index = 0; index < count; index++) {
            NSDictionary *dictData = arrData[index];
            if ((dictData[@"skipType"] == nil) ||
                ([dictData[@"skipType"] isEqualToString:@"photoset"]&&
                 [dictData[@"imgextra"] count] == 2)) {
                Model *model = [Model modelWithDictionary:dictData];
                [mArrModel addObject:model];
            }
        }
        success(mArrModel);
        
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
