//
//  WEShoppingCartCell.h
//  woeat
//
//  Created by liubin on 16/12/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEShoppingCartCell : UITableViewCell
@property(nonatomic, strong) UILabel *dishNameLabel;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UIButton *addButton;
@property(nonatomic, strong) UIButton *minusButton;
@end
