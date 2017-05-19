//
//  WEShoppingCartManager.h
//  woeat
//
//  Created by liubin on 16/12/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEShoppingCartManager : NSObject

+ (instancetype)sharedInstance;
- (NSDictionary *)loadKitchenCartToday:(NSString *)kitchenId;
- (NSDictionary *)loadKitchenCartTomorrow:(NSString *)kitchenId;
- (void)saveKitchenCartToday:(NSString *)kitchenId data:(NSDictionary *)dict;
- (void)saveKitchenCartTomorrow:(NSString *)kitchenId data:(NSDictionary *)dict;

- (void)removeKitchenCart:(NSString *)kitchenId isToday:(BOOL)isToday;
- (void)reInit;
@end
