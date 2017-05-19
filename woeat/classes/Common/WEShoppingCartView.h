//
//  WEShoppingCartView.h
//  woeat
//
//  Created by liubin on 16/12/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEModelGetTodayList;
@class WEModelGetConsumerKitchen;

@class WEShoppingCartView;
@protocol WEShoppingCartViewDelegate <NSObject>
- (void)itemAddOrMinus:(NSString *)itemId cartView:(WEShoppingCartView *)cartView;
@end


@interface WEShoppingCartView : UIView
@property(nonatomic, strong, readonly) UILabel *leftLabel;
@property(nonatomic, strong, readonly) UILabel *middleLabel;
@property(nonatomic, strong, readonly) UIButton *rightButton;
@property(nonatomic, assign) WEModelGetTodayList *allList;
@property(nonatomic, assign) NSString *kitchenId;
@property(nonatomic, assign) BOOL isToday;
@property(nonatomic, assign) UIViewController *parentController;
@property(nonatomic, assign) WEModelGetConsumerKitchen *kitchenInfo;
@property(nonatomic, weak) id<WEShoppingCartViewDelegate> itemDelegate;

- (float)getHeight;
- (void)addItem:(NSString *)itemId;

- (void)loadItems;
- (void)saveItems;

- (int)getItemSelectCount:(NSString *)itemId;
@end
