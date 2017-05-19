//
//  WELocationManager.m
//  woeat
//
//  Created by liubin on 17/1/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WELocationManager.h"
#import "WEOpenCity.h"
 #import <CoreLocation/CoreLocation.h>

@interface WELocationManager()<CLLocationManagerDelegate>
{
    double _latitude;
    double _longitude;
    
}
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation WELocationManager

+ (instancetype)sharedInstance
{
    static WELocationManager *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _state = WELocationManagerState_Init;
    }
    return self;
}

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
    }
    else
    {
        _state = WELocationManagerState_NO_AUTH;
        _errorDesc = @"请进入手机设置->隐私,打开定位服务";
        return;
        
    }
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"requestWhenInUseAuthorization");
        [self.locationManager requestWhenInUseAuthorization];
    }
    
//    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        NSLog(@"requestAlwaysAuthorization");
//        [self.locationManager requestAlwaysAuthorization];
//    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
    _state = WELocationManagerState_Updating;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    //NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
    _state = WELocationManagerState_UpdateSuccess;
    _latitude = coordinate.latitude;
    _longitude = coordinate.longitude;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    NSLog(@"location error %@", error);
    _state = WELocationManagerState_UpdateFail;
    if ([error code] == kCLErrorLocationUnknown) {
        _errorDesc = @"无法确定位置";
    }
    else if ([error code] == kCLErrorHeadingFailure){
        _errorDesc = @"获取朝向信息失败";
    }
    else if ([error code] == kCLErrorDenied){
        _errorDesc = @"用户拒绝访问定位服务";
    
    } else {
        _errorDesc = @"获取定位失败";
    }
}

- (double)getCurrentLatitude
{
    int stateId = [[WEOpenCity sharedInstance] getSelectStateId];
    int cityId = [[WEOpenCity sharedInstance] getSelectCityId];
    if (stateId>0 && cityId> 0) {
        return [self getCityLatitude];
    }
    
    return _latitude;
}

- (double)getCurrentLongitude
{
    int stateId = [[WEOpenCity sharedInstance] getSelectStateId];
    int cityId = [[WEOpenCity sharedInstance] getSelectCityId];
    if (stateId>0 && cityId> 0) {
        return [self getCityLongitude];
    }
    return _longitude;
}

- (double)getCityLatitude
{
    WEOpenCity *openCity = [WEOpenCity sharedInstance];
    double latitude = [openCity getSelectLatitude];
    if (latitude) {
        return latitude;
    } else {
        return 0;
    }
}

- (double)getCityLongitude
{
    WEOpenCity *openCity = [WEOpenCity sharedInstance];
    double longitude = [openCity getSelectLongitude];
    if (longitude) {
        return longitude;
    } else {
        return 0;
    }
}


@end
