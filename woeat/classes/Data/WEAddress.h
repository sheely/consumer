//
//  WEAddress.h
//  woeat
//
//  Created by liubin on 16/12/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEAddress : NSObject

@property(nonatomic, strong) NSString *personName;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *house;
@property(nonatomic, strong) NSString *stateName;
@property(nonatomic, strong) NSNumber *stateId;
@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, strong) NSString *postCode;
@property(nonatomic, strong) NSString *addressId;

- (NSString *)getAddressString;
@end
