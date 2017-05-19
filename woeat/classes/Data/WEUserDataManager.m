//
//  WEUserDataManager.m
//  woeat
//
//  Created by liubin on 17/1/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEUserDataManager.h"
#import "WEGlobalData.h"

#define CACHE_FILE   @"user.plist"
#define USER_DIR  @"user"

#define USER_NICK          @"USER_NICK"
#define USER_GENDER        @"USER_GENDER"
#define USER_BALANCE       @"USER_BALANCE"



@interface WEUserDataManager()
{
    NSMutableDictionary *_allData;
}
@end


@implementation WEUserDataManager
+ (instancetype)sharedInstance
{
    static WEUserDataManager *instance = nil;
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
        _allData = [NSMutableDictionary new];
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
    NSString *parentDir = [[WEGlobalData sharedInstance] getUserDir];
    return [parentDir stringByAppendingPathComponent:USER_DIR];
}


- (void)loadAll
{
    if (_allData.count) {
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
    _allData = [NSMutableDictionary new];
    for(NSString *key in dict) {
        id value = [dict objectForKey:key];
        [_allData setObject:value forKey:key];
    }
}

- (NSString *)getNick
{
    [self loadAll];
    return [_allData objectForKey:USER_NICK];
}

- (void)setNick:(NSString *)nick
{
    if (!nick.length) {
        return;
    }
    [self loadAll];
    [_allData setObject:nick forKey:USER_NICK];
    
}

- (BOOL)isMale
{
    [self loadAll];
    return [[_allData objectForKey:USER_GENDER] boolValue];
}

- (void)setMale:(BOOL)isMale
{
    [self loadAll];
    [_allData setObject:@(isMale) forKey:USER_GENDER];
}


- (NSNumber *)getBalance
{
    [self loadAll];
    return [_allData objectForKey:USER_BALANCE];
}

- (void)setBalance:(NSNumber *)balance
{
    [self loadAll];
    [_allData setObject:balance forKey:USER_BALANCE];
}

- (void)save
{
    NSString *dir = [self getCacheDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:CACHE_FILE];
    [_allData writeToFile:path atomically:YES];
}

- (void)reInit
{
    [self makeCacheDir];
    _allData = [NSMutableDictionary new];
}

@end
