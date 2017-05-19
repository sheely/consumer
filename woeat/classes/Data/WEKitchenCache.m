//
//  WEKitchenCache.m
//  woeat
//
//  Created by liubin on 16/12/27.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEKitchenCache.h"

#define CACHE_FILE   @"kitchen_cache.plist"

#define KITCHEN_NAME          @"KITCHEN_NAME"
#define KITCHEN_URL           @"KITCHEN_URL"
#define KITCHEN_CAN_PICKUP    @"KITCHEN_CAN_PICKUP"
#define KITCHEN_CAN_DELIVER   @"KITCHEN_CAN_DELIVER"

#define KITCHEN_DIR  @"kitchenCache"


@interface WEKitchenCache()
{
    NSMutableDictionary *_allKitchens;//id -> dict
}
@end

@implementation WEKitchenCache

+ (instancetype)sharedInstance
{
    static WEKitchenCache *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeCacheDir];
        _allKitchens = [NSMutableDictionary new];
    }
    
    return self;
}


- (void)makeCacheDir
{
    NSString *dir = [self getCacheDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"makeCacheDir %@", dir);
}

- (NSString *)getCacheDir
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:KITCHEN_DIR];
}


- (void)loadAll
{
    if (_allKitchens.count) {
        return;
    }
    
    NSString *dir = [self getCacheDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:CACHE_FILE];
    if(![fileManager fileExistsAtPath:path]) {
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _allKitchens = [NSMutableDictionary new];
    for(NSString *key in dict) {
        id value = [[dict objectForKey:key] mutableCopy];
        [_allKitchens setObject:value forKey:key];
    }
}

- (NSString *)getNameForKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSDictionary *dict = [_allKitchens objectForKey:kitchenId];
    return [dict objectForKey:KITCHEN_NAME];
}

- (NSString *)getImageUrlForKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSDictionary *dict = [_allKitchens objectForKey:kitchenId];
    return [dict objectForKey:KITCHEN_URL];
}

- (BOOL)getCanPickupForKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSDictionary *dict = [_allKitchens objectForKey:kitchenId];
    return [[dict objectForKey:KITCHEN_CAN_PICKUP] boolValue];
}

- (BOOL)getCanDiliverForKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSDictionary *dict = [_allKitchens objectForKey:kitchenId];
    return [[dict objectForKey:KITCHEN_CAN_DELIVER] boolValue];
}

- (void)setName:(NSString *)name forKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSMutableDictionary *dict = [_allKitchens objectForKey:kitchenId];
    if (!dict) {
        dict = [NSMutableDictionary new];
        [_allKitchens setObject:dict forKey:kitchenId];
    }
    [dict setObject:name forKey:KITCHEN_NAME];
}

- (void)setImageUrl:(NSString *)imageUrl forKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSMutableDictionary *dict = [_allKitchens objectForKey:kitchenId];
    if (!dict) {
        dict = [NSMutableDictionary new];
        [_allKitchens setObject:dict forKey:kitchenId];
    }
    [dict setObject:imageUrl forKey:KITCHEN_URL];
}

- (void)setCanPickup:(BOOL)canPickup forKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSMutableDictionary *dict = [_allKitchens objectForKey:kitchenId];
    if (!dict) {
        dict = [NSMutableDictionary new];
        [_allKitchens setObject:dict forKey:kitchenId];
    }
    [dict setObject:@(canPickup) forKey:KITCHEN_CAN_PICKUP];
}

- (void)setCanDiliver:(BOOL)canDiliver forKitchenId:(NSString *)kitchenId
{
    [self loadAll];
    NSMutableDictionary *dict = [_allKitchens objectForKey:kitchenId];
    if (!dict) {
        dict = [NSMutableDictionary new];
        [_allKitchens setObject:dict forKey:kitchenId];
    }
    [dict setObject:@(canDiliver) forKey:KITCHEN_CAN_DELIVER];
}

- (void)save
{
    NSString *dir = [self getCacheDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:CACHE_FILE];
    [_allKitchens writeToFile:path atomically:YES];
}


@end
