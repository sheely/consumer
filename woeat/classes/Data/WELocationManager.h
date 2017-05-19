//
//  WELocationManager.h
//  woeat
//
//  Created by liubin on 17/1/13.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WELocationManagerState) {
    WELocationManagerState_Init,
    WELocationManagerState_NO_AUTH,
    WELocationManagerState_Updating,
    WELocationManagerState_UpdateSuccess,
    WELocationManagerState_UpdateFail,
};


@interface WELocationManager : NSObject
@property(nonatomic, assign) WELocationManagerState state;
@property(nonatomic, strong) NSString *errorDesc;

+ (instancetype)sharedInstance;

- (void)startLocation;
- (double)getCurrentLatitude;
- (double)getCurrentLongitude;

@end
