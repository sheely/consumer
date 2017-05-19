//
//  WECityManager.m
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WECityManager.h"
#import "FMDatabase.h"
#import "WEState.h"
#import "WECity.h"

#define LOAD_CITY_COUNT  50

@interface WECityManager()
{
    NSMutableArray *_allStates; //array of WEState
    NSMutableDictionary *_allCityDB; //state id -> FMDB
    NSMutableArray *_currentCitys; // array of array of WECity
    NSString *_lastCityQueryString; //user can change search text
    int _lastStateId; // user can change state
    
}
@end

@implementation WECityManager
+ (instancetype)sharedInstance
{
    static WECityManager *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allStates = [[NSMutableArray alloc] initWithCapacity:52];
        _allCityDB = [NSMutableDictionary new];
        _currentCitys = [NSMutableArray new];
    }
    return self;
}

- (void)loadAllStates
{
    if (_allStates.count) {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"state" ofType:@"db"];
    if (!path.length) {
        NSLog(@"can not open state db");
        return;
    }
    
    FMDatabase * db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select stateId,Name,Code FROM state"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int stateId = [rs intForColumnIndex:0];
            NSString *Name = [rs stringForColumnIndex:1];
            NSString *Code = [rs stringForColumnIndex:2];
            WEState *state = [WEState new];
            state.stateId = stateId;
            state.Name = Name;
            state.Code = Code;
            [_allStates addObject:state];
        }
        [db close];
    }
}

- (NSArray *)getAllStatesWithQuery:(NSString *)queryString
{
    [self loadAllStates];
    if (!queryString.length) {
        return _allStates;
    }
    
    NSMutableSet *indexSet = nil;
    NSMutableArray *res = [NSMutableArray new];
    if (queryString.length <= 2) {
        indexSet = [NSMutableSet new];
        for(WEState *state in _allStates) {
            NSRange r = [state.Code rangeOfString:queryString options:NSCaseInsensitiveSearch];
            if (r.location != NSNotFound) {
                [res addObject:state];
                [indexSet addObject:@(state.stateId)];
            }
        }
    }
    for(WEState *state in _allStates) {
        if ([indexSet containsObject:@(state.stateId)]) {
            continue;
        }
        NSRange r = [state.Name rangeOfString:queryString options:NSCaseInsensitiveSearch];
        if (r.location != NSNotFound) {
            [res addObject:state];
        }
    }
    return res;
}

- (int)getCityCountWithStateId:(int)stateId query:(NSString *)queryString
{
    int count = 0;
    FMDatabase * db = [_allCityDB objectForKey:@(stateId)];
    if (!db) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", stateId] ofType:@"db"];
        if (!path.length) {
            NSLog(@"can not open city db %d", stateId);
            return 0;
        }
        db = [FMDatabase databaseWithPath:path];
        [_allCityDB setObject:db forKey:@(stateId)];
    }
    
    if ([db open]) {
        if (queryString.length) {
            NSString *lowerStr = [queryString lowercaseStringWithLocale:[NSLocale currentLocale]];
            NSString * sql = [NSString stringWithFormat:@"select count(*) FROM city where search like '%%%@%%'", lowerStr];
            FMResultSet *rs = [db executeQuery:sql];
            if ([rs next]) {
                count = [rs intForColumnIndex:0];
            }
            
        } else {
            NSString * sql = [NSString stringWithFormat:@"select count(*) FROM city"];
            FMResultSet *rs = [db executeQuery:sql];
            if ([rs next]) {
                count = [rs intForColumnIndex:0];
            }
        }
    }
    NSLog(@"getCityCountWithStateId stateId=%d, queryString=%@, count=%d", stateId, queryString, count);
    return count;
    
}

- (void)loadMoreCityWithDB:(FMDatabase *)db query:(NSString *)queryString minRowId:(int)minRowId
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:LOAD_CITY_COUNT];
    if ([db open]) {
        if (queryString.length) {
            NSString *lowerStr = [queryString lowercaseStringWithLocale:[NSLocale currentLocale]];
            NSString * sql = [NSString stringWithFormat:@"select id,Name,County FROM city where search like '%%%@%%' and id > %d limit %d", lowerStr, minRowId, LOAD_CITY_COUNT];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                int rowId = [rs intForColumnIndex:0];
                NSString *Name = [rs stringForColumnIndex:1];
                NSString *County = [rs stringForColumnIndex:2];
                WECity *city = [WECity new];
                city.rowId = rowId;
                city.Name = Name;
                city.County = County;
                [array addObject:city];
            }
            
        } else {
            NSString * sql = [NSString stringWithFormat:@"select id,Name,County FROM city where id > %d limit %d", minRowId, LOAD_CITY_COUNT];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                int rowId = [rs intForColumnIndex:0];
                NSString *Name = [rs stringForColumnIndex:1];
                NSString *County = [rs stringForColumnIndex:2];
                WECity *city = [WECity new];
                city.rowId = rowId;
                city.Name = Name;
                city.County = County;
                [array addObject:city];
            }
        }
    }
    [_currentCitys addObject:array];
    NSLog(@"loadMoreCityWithDB current total %d array, last array item count %d", _currentCitys.count, array.count);
}

- (WECity *)getCityWithStateId:(int)stateId query:(NSString *)queryString atIndex:(int)index
{
    if (_lastStateId != stateId) {
        NSLog(@"state id change, remove all old data, new %d, old %d", stateId, _lastStateId);
        [_currentCitys removeAllObjects];
        _lastStateId = stateId;
    }
    BOOL queryChange = NO;
    if (_lastCityQueryString) {
        if (![_lastCityQueryString isEqualToString:queryString]) {
            queryChange = YES;
        }
    } else {
        if (queryString) {
            queryChange = YES;
        }
    }
    
    if (queryChange) {
        NSLog(@"query change, remove all old data, new %@, old %@", queryString, _lastCityQueryString);
        [_currentCitys removeAllObjects];
        _lastCityQueryString = queryString;
    }
    
    
    FMDatabase * db = [_allCityDB objectForKey:@(stateId)];
    if (!db) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", stateId] ofType:@"db"];
        if (!path.length) {
            NSLog(@"can not open city db %d", stateId);
            return 0;
        }
        db = [FMDatabase databaseWithPath:path];
        [_allCityDB setObject:db forKey:@(stateId)];
    }
    
    int curIndex = index;
    for(NSArray *array in _currentCitys) {
        curIndex -= array.count;
        if (curIndex < 0) {
            return array[curIndex + array.count];
        }
    }
    int loadCount = index/LOAD_CITY_COUNT + 1 - _currentCitys.count;
    NSArray *array = _currentCitys.lastObject;
    WECity *city = array.lastObject;
    for(int i=0; i<loadCount; i++) {
        [self loadMoreCityWithDB:db query:queryString minRowId:city.rowId];
        array = _currentCitys.lastObject;
        city = array.lastObject;
    }
    
    curIndex = index;
    for(NSArray *array in _currentCitys) {
        curIndex -= array.count;
        if (curIndex < 0) {
            return array[curIndex + array.count];
        }
    }
    return nil;
    
}


- (WEState *)getStateWithStateId:(int)stateId
{
    [self loadAllStates];
    
    for(WEState *state in _allStates) {
        if (state.stateId == stateId) {
            return state;
        }
    }
    return nil;
}

- (int)getStateIdWithStateName:(NSString *)stateName
{
    [self loadAllStates];
    
    for(WEState *state in _allStates) {
        if ([state.Name isEqualToString:stateName]) {
            return state.stateId;
        }
    }
    return 0;
}




- (WECity *)getCityWithStateId:(int)stateId cityId:(int)cityId
{
    FMDatabase * db = [_allCityDB objectForKey:@(stateId)];
    if (!db) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", stateId] ofType:@"db"];
        if (!path.length) {
            NSLog(@"can not open city db %d", stateId);
            return 0;
        }
        db = [FMDatabase databaseWithPath:path];
        [_allCityDB setObject:db forKey:@(stateId)];
    }
    WECity *city = nil;
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select Name,Postcode,Latitude,Longitude FROM city where cityId =%d", cityId];
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            NSString *Name = [rs stringForColumnIndex:0];
            NSString *Postcode = [rs stringForColumnIndex:1];
            double Latitude = [rs doubleForColumnIndex:2];
            double Longitude = [rs doubleForColumnIndex:3];
            city = [WECity new];
            city.Name = Name;
            city.Postcode = Postcode;
            city.Longitude = Longitude;
            city.Latitude = Latitude;
            city.cityId = cityId;
        }
    }
    return city;
}
@end
