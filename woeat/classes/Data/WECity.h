//
//  WECity.h
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WECity : NSObject

@property(nonatomic, assign) int rowId;
@property(nonatomic, assign) int cityId;
@property(nonatomic, strong) NSString* Name;
@property(nonatomic, strong) NSString* County;
@property(nonatomic, strong) NSString* Postcode;
@property(nonatomic, assign) double Latitude;
@property(nonatomic, assign) double Longitude;
@end
