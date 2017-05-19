//
//  WEToken.h
//  woeat
//
//  Created by liubin on 17/1/9.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEToken : NSObject

+ (NSString *)getToken;
+ (void)saveToken:(NSString *)token;
+ (void)clearToken;


@end
