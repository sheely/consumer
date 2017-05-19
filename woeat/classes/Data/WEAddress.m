//
//  WEAddress.m
//  woeat
//
//  Created by liubin on 16/12/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEAddress.h"

@implementation WEAddress

- (NSString *)getAddressString
{
    NSMutableString *s = [NSMutableString new];
    [s appendFormat:@"%@, %@, %@\n", _house, _cityName, _stateName];
    [s appendFormat:@"%@ %@", _personName, _phone];
    return s;
}


@end

