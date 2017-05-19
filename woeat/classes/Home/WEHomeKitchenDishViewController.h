//
//  WEHomeKitchenDishViewController.h
//  woeat
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WEModelGetTodayList;
@class WEModelGetConsumerKitchen;
@interface WEHomeKitchenDishViewController : UIViewController

@property(nonatomic, strong) WEModelGetTodayList *modelItemToday;
@property(nonatomic, strong) WEModelGetTodayList *modelItemTomorrow;
@property(nonatomic, strong) WEModelGetConsumerKitchen *modelGetConsumerKitchen;
@property(nonatomic, strong) NSString *kitchenId;
@property(nonatomic, strong) NSString *itemId;
@end
