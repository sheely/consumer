//
//  WEState.h
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEState : NSObject

@property(nonatomic, assign) int stateId;
@property(nonatomic, strong) NSString* Name;
@property(nonatomic, strong) NSString* Code;
@end
