//
//  WEHomeKitchenStoryViewController.h
//  woeat
//
//  Created by liubin on 16/10/24.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WECustomNavButtonViewController.h"

@class WEModelGetConsumerKitchen;
@interface WEHomeKitchenStoryViewController : WECustomNavButtonViewController

@property(nonatomic, strong) WEModelGetConsumerKitchen *modelGetConsumerKitchen;
@property(nonatomic, strong) NSString *kitchenId;
@end
