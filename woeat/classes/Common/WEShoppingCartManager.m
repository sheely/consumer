//
//  WEShoppingCartManager.m
//  woeat
//
//  Created by liubin on 16/12/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEShoppingCartManager.h"
#import "WEGlobalData.h"

#define TODAY_NAME      @"today.plist"
#define TOMORROW_NAME   @"tomorrow.plist"

#define CART_DIR @"cart"

@implementation WEShoppingCartManager
+ (instancetype)sharedInstance
{
    static WEShoppingCartManager *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeCartDir];
    }
    
    return self;
}


- (void)makeCartDir
{
    NSString *dir = [self getCartDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"makeCartDir %@", dir);
}

- (NSString *)getCartDir
{
    NSString *parentDir = [[WEGlobalData sharedInstance] getUserDir];
    return [parentDir stringByAppendingPathComponent:CART_DIR];
}


- (void)makeKitchenDir:(NSString *)kitchenId
{
    NSString *dir = [self getKichenDir:kitchenId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)getKichenDir:(NSString *)kitchenId
{
     NSString *dir = [self getCartDir];
    return [dir stringByAppendingPathComponent:kitchenId];
}

//itemId -> number
- (NSDictionary *)loadKitchenCartToday:(NSString *)kitchenId
{
    NSString *dir = [self getKichenDir:kitchenId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return nil;
    }
    NSString *path = [dir stringByAppendingPathComponent:TODAY_NAME];
    if(![fileManager fileExistsAtPath:path]) {
        return nil;
    }
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

- (NSDictionary *)loadKitchenCartTomorrow:(NSString *)kitchenId
{
    NSString *dir = [self getKichenDir:kitchenId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return nil;
    }
    NSString *path = [dir stringByAppendingPathComponent:TOMORROW_NAME];
    if(![fileManager fileExistsAtPath:path]) {
        return nil;
    }
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

- (void)saveKitchenCartToday:(NSString *)kitchenId data:(NSDictionary *)dict
{
    NSString *dir = [self getKichenDir:kitchenId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        [self makeKitchenDir:kitchenId];
    }
    NSString *path = [dir stringByAppendingPathComponent:TODAY_NAME];
    [dict writeToFile:path atomically:YES];
}

- (void)saveKitchenCartTomorrow:(NSString *)kitchenId data:(NSDictionary *)dict
{
    NSString *dir = [self getKichenDir:kitchenId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        [self makeKitchenDir:kitchenId];
    }
    NSString *path = [dir stringByAppendingPathComponent:TOMORROW_NAME];
    [dict writeToFile:path atomically:YES];
}


- (void)removeKitchenCart:(NSString *)kitchenId isToday:(BOOL)isToday
{
     NSString *dir = [self getKichenDir:kitchenId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path;
    if (isToday) {
         path = [dir stringByAppendingPathComponent:TODAY_NAME];
    } else {
        path = [dir stringByAppendingPathComponent:TOMORROW_NAME];
    }
    NSError *error = nil;
    [fileManager removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"removeItemAtPath error %@ %@", path, error);
    }
}

- (void)reInit
{
    [self makeCartDir];
}

@end
