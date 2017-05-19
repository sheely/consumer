//
//  WEGlobalData.m
//  woeat
//
//  Created by liubin on 16/12/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEGlobalData.h"
#import "WEShoppingCartManager.h"
#import "WEKitchenCache.h"
#import "WEUserDataManager.h"
#import "WEAddressManager.h"

@interface WEGlobalData()
{
    NSString *_curUserName;
}

@end

@implementation WEGlobalData

+ (instancetype)sharedInstance
{
    static WEGlobalData *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

-(NSString *)curUserName
{
    if (!_curUserName) {
        NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PHONE];
        _curUserName = phone;
    }
    return _curUserName;
}

- (void)setCurUserName:(NSString *)curUserName
{
    _curUserName = curUserName;
    
}


- (NSString *)getUserDir
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:self.curUserName];
}


+ (void)logOut
{
    //shopping cart
    
    //address manager
    //[[WEAddressManager sharedInstance] save];
    
    //kitchen cache
    
    //user data
    [[WEUserDataManager sharedInstance] save];
    
    //profile image
    

}

+ (void)logIn
{
    //shopping cart
    [[WEShoppingCartManager sharedInstance] reInit];
    
    //address manager
    [[WEAddressManager sharedInstance] reInit];
    
    //kitchen cache
    
    //user data
    [[WEUserDataManager sharedInstance] reInit];
    
    //profile image
    
    
}

+ (void)quitBackground
{
    //shopping cart
    
    //address manager
    //[[WEAddressManager sharedInstance] save];
    
    //kitchen cache
    [[WEKitchenCache sharedInstance] save];
    
    //user data
    [[WEUserDataManager sharedInstance] save];
    
    //profile image
}

@end
