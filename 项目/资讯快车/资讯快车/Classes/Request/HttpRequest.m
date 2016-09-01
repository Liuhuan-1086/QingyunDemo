//
//  HttpRequest.m
//  程序部落
//
//  Created by qingyun on 16/8/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

@interface HttpRequest ()

@end

@implementation HttpRequest

//线程安全的方式创建单例
+ (instancetype)shareHttpRequest {
    static HttpRequest *httpRequest;
    static dispatch_once_t onceHttpRequest;
    __weak typeof(self) weakSelf = self;
    dispatch_once(&onceHttpRequest, ^{
        httpRequest = [[[weakSelf class] alloc] init];
    });
    return httpRequest;
}

//Get请求
- (void)Get:(NSString *)url Param:(NSDictionary *)dictData Success:(void (^)(id responseData))success Failure:(void (^)(NSError *error))failure {
    //创建manager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置响应的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html", nil];
    //发送请求
    [manager GET:url parameters:dictData progress:nil
     //网络请求成功时（服务器端有回应）调用的block块
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             success(responseObject);
         }
     //网络请求失败时（网络错误）调用的block块
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failure(error);
         }];
}

//Post请求
- (void)Post:(NSString *)url Param:(NSDictionary *)dictData Success:(void (^)(id responseData))success Failure:(void (^)(NSError *error))failure {
    //创建manager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置响应的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json","text/html", nil];
    //发送请求
    [manager POST:url parameters:dictData progress:nil
     //网络请求成功时（服务器端有回应）调用的block块
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              success(responseObject);
          }
     //网络请求失败时（网络错误）调用的block块
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"网络请求错误%@",error);
              failure(error);
          }];
}

@end
