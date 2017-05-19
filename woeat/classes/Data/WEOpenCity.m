//
//  WEOpenCity.m
//  woeat
//
//  Created by liubin on 17/1/12.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEOpenCity.h"
#import "WECityManager.h"
#import "WEState.h"
#import "WECity.h"



#define USER_DEFAULT_OPEN_STATE_ID  @"USER_DEFAULT_OPEN_STATE_ID"
#define USER_DEFAULT_OPEN_CITY_ID   @"USER_DEFAULT_OPEN_CITY_ID"



@interface WEOpenCity()
{
    NSArray *_stateIdArray;
    NSMutableArray *_stateArray;
    NSMutableDictionary *_stateIdToCityIdArray;
    NSMutableDictionary *_stateIdToCityArray;
}
@end

@implementation WEOpenCity

+ (instancetype)sharedInstance
{
    static WEOpenCity *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stateIdArray = @[@(100004)];
        _stateIdToCityIdArray = @{@(100004) : @[@(10037706),
                                                @(10037967),
                                                @(10037914),
                                                @(10037932),
                                                @(10037928),
                                                @(10037950),
                                                ] };
        
        WECityManager *manager = [WECityManager sharedInstance];
        _stateArray = [NSMutableArray new];
        for(NSNumber *stateId in _stateIdArray) {
            WEState *state = [manager getStateWithStateId:stateId.integerValue];
            [_stateArray addObject:state];
        }
        
        _stateIdToCityArray = [NSMutableDictionary new];
        for(NSString *stateId in _stateIdToCityIdArray) {
            NSArray *cityIds = [_stateIdToCityIdArray objectForKey:stateId];
            NSMutableArray *cityArray = [[NSMutableArray alloc] initWithCapacity:cityIds.count];
            [_stateIdToCityArray setObject:cityArray forKey:stateId];
            
            for(NSNumber *cityId in cityIds) {
                WECity *city = [manager getCityWithStateId:stateId.integerValue cityId:cityId.integerValue];
                [cityArray addObject:city];
            }
            
        }
        
        //tmp
        if (![self getSelectStateId]) {
            [self setSelectStateId:[_stateIdArray[0] integerValue]];
        }
    }
    
    return self;
}

- (NSArray *)getStateArray
{
    return _stateArray;
}

- (NSArray *)getCityArrayWithStateId:(int)stateId
{
    return [_stateIdToCityArray objectForKey:@(stateId)];
}

- (int)getSelectStateId
{
    NSNumber *stateId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_OPEN_STATE_ID];
    return [stateId integerValue];
}

- (void)setSelectStateId:(int)stateId
{
    [[NSUserDefaults standardUserDefaults] setObject:@(stateId) forKey:USER_DEFAULT_OPEN_STATE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)getSelectCityId
{
    NSNumber *stateId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_OPEN_CITY_ID];
    return [stateId integerValue];
}

- (void)setSelectCityId:(int)cityId
{
    [[NSUserDefaults standardUserDefaults] setObject:@(cityId) forKey:USER_DEFAULT_OPEN_CITY_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (WECity *)getSelectCity
{
    int stateId = [self getSelectStateId];
    int cityId = [self getSelectCityId];
    NSArray *array = [self getCityArrayWithStateId:stateId];
    for(WECity *city in array) {
        if (city.cityId == cityId) {
            return city;
        }
    }
    return nil;
}


- (double)getSelectLatitude
{
    WECity *city = [self getSelectCity];
    if (city) {
        return city.Latitude;
    }
    return 0;
}

- (double)getSelectLongitude
{
    WECity *city = [self getSelectCity];
    if (city) {
        return city.Longitude;
    }
    return 0;
}

@end
