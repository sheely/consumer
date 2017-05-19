//
//  WEOrderDishListView.h
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEModelOrder;
@class WEModelGetConsumerKitchen;

@interface WEOrderDishListView : UIView

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BOOL showHeader;
@property(nonatomic, strong) WEModelOrder *order;
@property(nonatomic, strong) WEModelGetConsumerKitchen *kitchenInfo;
@end
