//
//  QYLocationMnager.m
//  Yueba
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYLocationManager.h"
#import "Account.h"
#import "UserInfo.h"


@interface QYLocationManager ()<BMKLocationServiceDelegate, BMKRadarManagerDelegate>

@property (nonatomic, strong)BMKLocationService *locationService;//位置管理器(bd 封装)
@property (nonatomic, strong)BMKRadarManager *radarManager;
@property (nonatomic)CLLocationCoordinate2D coordinate;//当前定位的位置

@end

@implementation QYLocationManager

-(void)dealloc{
    //释放周边雷达服务
    [_radarManager removeRadarManagerDelegate:self];
    [BMKRadarManager releaseRadarManagerInstance];
}

+(instancetype)shareLocationManager{
    static QYLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QYLocationManager alloc] init];
    });
    return manager;
}

-(void)startLocationService{
    [self.locationService startUserLocationService];//开始定位
}

//初始化定位服务器
-(BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.distanceFilter = 100.f;//最小的更新距离
        _locationService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationService.delegate = self;
    }
    return _locationService;
}

-(BMKRadarManager *)radarManager{
    if (!_radarManager) {
        _radarManager = [BMKRadarManager getRadarManagerInstance];
        _radarManager.userId = [[Account shareAccount] objectId];
        [_radarManager addRadarManagerDelegate:self];
    }
    return _radarManager;
}

#pragma mark - 定位delegate

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"%@", userLocation);
    self.coordinate = userLocation.location.coordinate;
    //调用block,更新位置
    if (_locationUpdate) {
        _locationUpdate(userLocation.location.coordinate);
    }
    
    //定位成功后,上传位置信息
    
    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];
    info.pt = userLocation.location.coordinate;//指定位置信息
    info.extInfo = @"hello";
    
    BOOL result = [self.radarManager uploadInfoRequest:info];
    NSLog(@"upload bengin:%d", result);
    
}

#pragma mark - radar delegate
//上传用户信息结果
-(void)onGetRadarUploadResult:(BMKRadarErrorCode)error{
    NSLog(@"upload result:%d", error);
    //查找周围的用户
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init];
    option.radius = 8000.f;//搜索半径
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;//排序方式
    option.centerPt = self.coordinate;
    
    BOOL result = [self.radarManager getRadarNearbySearchRequest:option];
    NSLog(@"检索开始:%d", result);
}
//搜索周围用户结果
-(void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error{
    NSLog(@"搜索结果:%d", error);
    if (error != 0) {
        return;
    }
    
    //处理结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:result.totalNum];
    for (NSUInteger index = 0; index < result.pageNum; index ++) {
        result.pageIndex = index;
        [resultArray addObjectsFromArray:result.infoList];
    }
    
//    将所有对象转化为model
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (BMKRadarNearbyInfo *info in resultArray) {
        UserInfo *user = [[UserInfo alloc] init];
        user.userID = info.userId;
        user.coordinate = info.pt;//用户的位置
        [modelArray addObject:user];
    }
    
    if (self.radarNear) {
        self.radarNear(modelArray);
    }
    
}





@end
