//
//  WEGlobalData.h
//  woeat
//
//  Created by liubin on 16/12/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WEModelGetMyCardList;

@interface WEGlobalData : NSObject

@property(nonatomic, strong) NSString *selectedCouponId;
@property(nonatomic, strong) NSString *selectedCouponDesc;
@property(nonatomic, strong) NSArray *orderCommentArray;
@property(nonatomic, strong) WEModelGetMyCardList *curCardList;

-(NSString *)curUserName;
- (void)setCurUserName:(NSString *)curUserName;

+ (instancetype)sharedInstance;
- (NSString *)getUserDir;


+ (void)logOut;
+ (void)logIn;
+ (void)quitBackground;
@end
