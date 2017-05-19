//
//  WEOpenCity.h
//  woeat
//
//  Created by liubin on 17/1/12.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEOpenCity : NSObject
+ (instancetype)sharedInstance;

- (NSArray *)getStateArray;
- (NSArray *)getCityArrayWithStateId:(int)stateId;
- (int)getSelectStateId;
- (void)setSelectStateId:(int)stateId;
- (int)getSelectCityId;
- (void)setSelectCityId:(int)cityId;

- (double)getSelectLatitude;
- (double)getSelectLongitude;
@end
