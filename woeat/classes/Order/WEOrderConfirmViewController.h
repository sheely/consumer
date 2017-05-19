//
//  WEOrderConfirmViewController.h
//  woeat
//
//  Created by liubin on 16/12/18.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WECustomNavButtonViewController.h"

@class WEModelGetConsumerKitchen;
@interface WEOrderConfirmViewController : WECustomNavButtonViewController


@property(nonatomic, strong) WEModelGetConsumerKitchen *kitchenInfo;
@property(nonatomic, assign) BOOL isToday;
@property(nonatomic, strong) NSString *orderId;
@end
