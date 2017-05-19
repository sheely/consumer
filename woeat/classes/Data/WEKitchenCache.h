//
//  WEKitchenCache.h
//  woeat
//
//  Created by liubin on 16/12/27.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEKitchenCache : NSObject

+ (instancetype)sharedInstance;
- (NSString *)getNameForKitchenId:(NSString *)kitchenId;
- (NSString *)getImageUrlForKitchenId:(NSString *)kitchenId;
- (BOOL)getCanPickupForKitchenId:(NSString *)kitchenId;
- (BOOL)getCanDiliverForKitchenId:(NSString *)kitchenId;

- (void)setName:(NSString *)name forKitchenId:(NSString *)kitchenId;
- (void)setImageUrl:(NSString *)imageUrl forKitchenId:(NSString *)kitchenId;
- (void)setCanPickup:(BOOL)canPickup forKitchenId:(NSString *)kitchenId;
- (void)setCanDiliver:(BOOL)canDiliver forKitchenId:(NSString *)kitchenId;

- (void)save;
@end
