//
//  QYLocationMnager.h
//  Yueba
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>

//定位成功的block
typedef void(^LocationUpdate)(CLLocationCoordinate2D coordinate);
//检索成功的block
typedef void (^RadarNear)(NSArray *reuslt);

@interface QYLocationManager : NSObject

@property (nonatomic, copy)LocationUpdate locationUpdate;//定位成功的回调block;
@property (nonatomic, copy)RadarNear radarNear;//检索成功的回调block

//单例方法
+(instancetype)shareLocationManager;

//开启定位服务
-(void)startLocationService;

@end
