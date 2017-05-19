//
//  WEOrderDetailViewController.h
//  woeat
//
//  Created by liubin on 16/11/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEModelOrder;
@class WEModelGetConsumerKitchen;

@interface WEOrderDetailViewController : UIViewController

@property(nonatomic, strong) WEModelOrder *order;
@property(nonatomic, strong) WEModelGetConsumerKitchen *kitchenInfo;
@property(nonatomic, assign) BOOL isToday;
@end
