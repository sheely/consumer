//
//  UmengStat.m
//  ClipPlus
//
//  Created by liubin on 16/7/16.
//  Copyright © 2016年 Sense-U. All rights reserved.
//

#import "UmengStat.h"
#import "UMMobClick/MobClick.h"

@implementation UmengStat

+ (void)initWithAppKey:(NSString *)appkey
{
    UMConfigInstance.appKey = appkey;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
}

+ (void)pageEnter:(NSString *)pageName
{
    [MobClick beginLogPageView:pageName];
}


+ (void)pageLeave:(NSString *)pageName
{
    [MobClick endLogPageView:pageName];
}

+ (void)signIn:(NSString *)userName
{
    [MobClick profileSignInWithPUID:userName];
}

+ (void)signOut
{
    [MobClick profileSignOff];
}

+ (void)event:(NSString *)event type:(NSString *)type platform:(NSString *)platform
{
   
}


@end
