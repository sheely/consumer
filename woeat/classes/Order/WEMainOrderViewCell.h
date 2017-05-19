//
//  WEMainOrderViewCell.h
//  woeat
//
//  Created by liubin on 16/11/16.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum WEMainOrderViewCellType{
    WEMainOrderViewCellType_ON_GOING,
    WEMainOrderViewCellType_WAIT_COMMENT,
    WEMainOrderViewCellType_FINISHED,
    
}WEMainOrderViewCellType;


@class WEModelOrder;
@interface WEMainOrderViewCell : UITableViewCell


@property(nonatomic, assign) WEMainOrderViewCellType type;
@property(nonatomic, weak) UIViewController *controller;

+ (float)getHeightWithType:(WEMainOrderViewCellType)type;
- (void)setData:(WEModelOrder *)data;
@end
