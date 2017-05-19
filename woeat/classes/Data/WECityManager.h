//
//  WECityManager.h
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WECity;
@class WEState;
@interface WECityManager : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)getAllStatesWithQuery:(NSString *)queryString;

- (int)getCityCountWithStateId:(int)stateId query:(NSString *)queryString;
- (WECity *)getCityWithStateId:(int)stateId query:(NSString *)queryString atIndex:(int)index;

- (WEState *)getStateWithStateId:(int)stateId;
- (int)getStateIdWithStateName:(NSString *)stateName;
- (WECity *)getCityWithStateId:(int)stateId cityId:(int)cityId;
@end
