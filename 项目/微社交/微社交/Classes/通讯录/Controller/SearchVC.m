//
//  SearchVC.m
//  Yueba
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SearchVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "QYLocationManager.h"

@interface SearchVC ()<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[QYLocationManager shareLocationManager] startLocationService];
    __weak SearchVC *search = self;
    [[QYLocationManager shareLocationManager] setLocationUpdate:^(CLLocationCoordinate2D coordinate){
        //更新地图的中心点
        BMKCoordinateRegion region = search.mapView.region;
        region.center = coordinate;
        search.mapView.region = region;
        //显示的区域
        search.mapView.zoomLevel = 16;
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //让动画旋转
    [self animationRotating];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

//将地图显示为圆型
-(void)viewDidLayoutSubviews{
    self.mapView.layer.cornerRadius = self.mapView.bounds.size.width/2;
    self.mapView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//旋转动画
-(void)animationRotating{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:-2 * M_PI];//变化范围
    animation.duration = 5.f;//时间
    animation.repeatCount = MAXFLOAT;//循环次数
    animation.cumulative = YES;//动画结束复位;
    
    //添加动画
    [_imageView.layer removeAllAnimations];
    [_imageView.layer addAnimation:animation forKey:@"transform.rotation.z"];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
