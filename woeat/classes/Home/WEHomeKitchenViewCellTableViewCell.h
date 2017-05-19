//
//  WEHomeKitchenViewCellTableViewCell.h
//  woeat
//
//  Created by liubin on 16/10/21.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEModelGetTodayList.h"

@interface WEHomeKitchenViewCellTableViewCell : UITableViewCell

@property(nonatomic, assign) BOOL isEmpty;
@property(nonatomic, strong) UIButton *addButton;

- (void)setModel:(WEModelGetTodayListItemList *)model;
- (void)setCurrentAmount:(int)amount;

@end
