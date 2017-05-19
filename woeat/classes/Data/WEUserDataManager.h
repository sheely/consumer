//
//  WEUserDataManager.h
//  woeat
//
//  Created by liubin on 17/1/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEUserDataManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getNick;
- (void)setNick:(NSString *)nick;
- (BOOL)isMale;
- (void)setMale:(BOOL)isMale;
- (NSNumber *)getBalance;
- (void)setBalance:(NSNumber *)balance;
- (void)save;
- (void)reInit;
@end
