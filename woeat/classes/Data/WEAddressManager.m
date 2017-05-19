//
//  WEAddressManager.m
//  woeat
//
//  Created by liubin on 16/12/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEAddressManager.h"
#import "WEAddress.h"
#import "WEGlobalData.h"
#import "WENetUtil.h"
#import "WEModelGetMyDeliveryAddressList.h"
#import "WECityManager.h"
#import "WEModelCommon.h"

#define FAIL_NAME   @"fail.plist"
#define INFO_NAME   @"info.plist"
#define KEY_SELECT  @"KEY_SELECT"

#define ADDRESS_DIR  @"addr"

@interface WEAddressManager()
{
    NSMutableArray *_allAddress;
    int _selectedIndex;
}
@end

@implementation WEAddressManager

+ (instancetype)sharedInstance
{
    static WEAddressManager *instance = nil;
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeAddressDir];
        _allAddress = [NSMutableArray new];
        _selectedIndex = 0;
    }
    
    return self;
}

- (NSArray *)allAddress
{
    return _allAddress;
}

- (void)makeAddressDir
{
    NSString *dir = [self getAddrDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"makeAddressDir %@", dir);
}

- (NSString *)getAddrDir
{
    NSString *parentDir = [[WEGlobalData sharedInstance] getUserDir];
    return [parentDir stringByAppendingPathComponent:ADDRESS_DIR];
}

- (void)saveFail:(NSArray *)fail
{
    NSMutableArray *res = [NSMutableArray new];
    for(WEAddress *a in fail) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:a.personName forKey:@"personName"];
        [dict setObject:a.phone forKey:@"phone"];
        [dict setObject:a.house forKey:@"house"];
        [dict setObject:a.stateId forKey:@"stateId"];
        [dict setObject:a.stateName forKey:@"stateName"];
        [dict setObject:a.cityName forKey:@"cityName"];
        [dict setObject:a.postCode forKey:@"postCode"];
        
        [res addObject:dict];
    }
    
    NSString *dir = [self getAddrDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:FAIL_NAME];
    [res writeToFile:path atomically:YES];
}

- (void)addFail:(WEAddress *)a
{
    NSString *dir = [self getAddrDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:FAIL_NAME];
    if(![fileManager fileExistsAtPath:path]) {
        return;
    }
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *fail = [NSMutableArray new];
    [fail addObjectsFromArray:array];
    [fail addObject:a];
    [self saveFail:fail];
}

- (void)uploadFail
{
    NSString *dir = [self getAddrDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:FAIL_NAME];
    if(![fileManager fileExistsAtPath:path]) {
        return;
    }
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *fail = [NSMutableArray new];
    __block int count = 0;
    for(NSDictionary *dict in array) {
        WEAddress *a = [WEAddress new];
        a.personName = [dict objectForKey:@"personName"];
        a.phone = [dict objectForKey:@"phone"];
        a.house = [dict objectForKey:@"house"];
        a.stateName = [dict objectForKey:@"stateName"];
        a.stateId = [dict objectForKey:@"stateId"];
        a.cityName = [dict objectForKey:@"cityName"];
        a.postCode = [dict objectForKey:@"postCode"];
        a.addressId = [dict objectForKey:@"postCode"];
        [WENetUtil AddDeliveryAddressWithContactName:a.personName
                                         PhoneNumber:a.phone
                                        DisplayOrder:0
                                        AddressLine1:a.house
                                                City:a.cityName
                                               State:a.stateName
                                            Postcode:a.postCode
                                           Longitude:@"0"
                                            Latitude:@"0"
                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                 JSONModelError* error = nil;
                                                 WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                                 if (error) {
                                                     NSLog(@"error %@", error);
                                                 }
                                                 count++;
                                                 if (!res.IsSuccessful) {
                                                     [fail addObject:a];
                                                 }
                                                 if (count == array.count) {
                                                     [self saveFail:fail];
                                                 }
                                                 
                                             } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                 count++;
                                                 [fail addObject:a];
                                                 if (count == array.count) {
                                                     [self saveFail:fail];
                                                 }
                                             }];
    }

}

- (void)addAddress:(WEAddress *)a withDelegate:(id<WEAddressManagerDelegate>)delegate
{
    [WENetUtil AddDeliveryAddressWithContactName:a.personName
                                     PhoneNumber:a.phone
                                    DisplayOrder:0
                                    AddressLine1:a.house
                                            City:a.cityName
                                           State:a.stateName
                                        Postcode:a.postCode
                                       Longitude:@"0"
                                        Latitude:@"0"
                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                             JSONModelError* error = nil;
                                             WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:responseObject error:&error];
                                             if (error) {
                                                 NSLog(@"error %@", error);
                                             }
                                            if (!res.IsSuccessful) {
                                                [self addFail:a];
                                             }
                                             [_allAddress removeAllObjects];
                                             [delegate addFinished];
                                             [self loadAllWithDelegate:delegate];
                                             
                                         } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                             [self addFail:a];
                                             [delegate addFinished];
                                         }];
}

- (void)loadAllWithDelegate:(id<WEAddressManagerDelegate>)delegate
{
    if (_allAddress.count) {
        [delegate loadFinished];
        return;
    }
    [delegate loadStart];
    [self uploadFail];
    [WENetUtil GetMyDeliveryAddressListWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyDeliveryAddressList *model = [[WEModelGetMyDeliveryAddressList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (!model.IsSuccessful) {
            return;
        }
        [_allAddress removeAllObjects];
        WEAddressManager *manager = [WEAddressManager sharedInstance];
        for(WEModelGetMyDeliveryAddressListAddressList *addr in model.AddressList) {
            WEAddress *a = [WEAddress new];
            a.personName = addr.ContactName;
            a.phone = addr.PhoneNumber;
            a.house = addr.AddressLine1;
            a.stateName = addr.State;
            a.cityName = addr.City;
            a.postCode = addr.Postcode;
            WECityManager *manager = [WECityManager sharedInstance];
            a.stateId = @([manager getStateIdWithStateName:a.stateName]);
            a.addressId = addr.Id;
            [_allAddress addObject:a];
        }
        [delegate loadFinished];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        [delegate loadFinished];
    }];

}

- (void)deleteAddress:(WEAddress *)a withDelegate:(id<WEAddressManagerDelegate>)delegate
{
    [WENetUtil DeleteDeliveryAddressWithAddressId:a.addressId
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              [_allAddress removeAllObjects];
                                              [self loadAllWithDelegate:delegate];
                                              [delegate deleteFinished];
                                              
                                          } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                              [delegate deleteFinished];
                                          }];
}

- (void)modifyAddress:(WEAddress *)a withDelegate:(id<WEAddressManagerDelegate>)delegate
{
    [WENetUtil DeleteDeliveryAddressWithAddressId:a.addressId
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                              [self addAddress:a withDelegate:delegate];
                                              
                                          } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                              [delegate addFinished];
                                          }];
}

//
//- (BOOL)localExist:(WEModelGetMyDeliveryAddressListAddressList *)addr
//{
//    for(WEAddress *a in _allAddress) {
//        if (![a.personName isEqualToString:addr.ContactName]) {
//            continue;
//        }
//        if (![a.phone isEqualToString:addr.PhoneNumber]) {
//            continue;
//        }
//        if (![a.house isEqualToString:addr.AddressLine1]) {
//            continue;
//        }
//        if (![a.stateName isEqualToString:addr.State]) {
//            continue;
//        }
//        if (![a.cityName isEqualToString:addr.City]) {
//            continue;
//        }
//        if (![a.postCode isEqualToString:addr.Postcode]) {
//            continue;
//        }
//        return YES;
//    }
//    return NO;
//}


- (int)readSelectedIndex
{
    NSString *dir = [self getAddrDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return 0;
    }
    NSString *path = [dir stringByAppendingPathComponent:INFO_NAME];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [[dict objectForKey:KEY_SELECT] integerValue];
}

- (void)writeSelectedIndex:(int)i
{
    NSString *dir = [self getAddrDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dir]) {
        return;
    }
    NSString *path = [dir stringByAppendingPathComponent:INFO_NAME];
    NSDictionary *dict = @{@"KEY_SELECT" : @(i)};
    
    [dict writeToFile:path atomically:YES];
}

- (int)getSelectedIndex
{
    _selectedIndex = [self readSelectedIndex];
    return _selectedIndex;
}

- (void)setSelectedIndex:(int)index
{
    _selectedIndex = index;
    [self writeSelectedIndex:_selectedIndex];
}

- (void)selectLastAdd
{
    _selectedIndex = [_allAddress count] - 1;
    [self writeSelectedIndex:_selectedIndex];
}

- (void)reInit
{
    [self makeAddressDir];
    _allAddress = [NSMutableArray new];
    
}
@end
