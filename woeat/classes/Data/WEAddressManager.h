//
//  WEAddressManager.h
//  woeat
//
//  Created by liubin on 16/12/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WEAddressManagerDelegate <NSObject>

- (void)loadStart;
- (void)loadFinished;
- (void)deleteFinished;
- (void)addFinished;
@end

@class WEAddress;
@interface WEAddressManager : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)allAddress;


- (void)loadAllWithDelegate:(id<WEAddressManagerDelegate>)delegate;

- (void)addAddress:(WEAddress *)a withDelegate:(id<WEAddressManagerDelegate>)delegate;
- (void)deleteAddress:(WEAddress *)a withDelegate:(id<WEAddressManagerDelegate>)delegate;
- (void)modifyAddress:(WEAddress *)a withDelegate:(id<WEAddressManagerDelegate>)delegate;

- (int)getSelectedIndex;
- (void)setSelectedIndex:(int)index;
- (void)selectLastAdd;
- (void)reInit;

@end
