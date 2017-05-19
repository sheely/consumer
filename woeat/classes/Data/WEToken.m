//
//  WEToken.m
//  woeat
//
//  Created by liubin on 17/1/9.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEToken.h"

@implementation WEToken

+ (NSString *)getToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_TOKEN];
    return token;
}

+ (void)saveToken:(NSString *)token
{
    if (!token.length) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_DEFAULT_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)clearToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
