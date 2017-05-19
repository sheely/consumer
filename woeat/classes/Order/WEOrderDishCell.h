//
//  WEOrderDishCell.h
//  woeat
//
//  Created by liubin on 16/11/17.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEModelOrderLines;
@interface WEOrderDishCell : UITableViewCell

@property(nonatomic, strong) WEModelOrderLines *model;
@end
