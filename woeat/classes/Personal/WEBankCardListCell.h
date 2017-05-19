//
//  WEBankCardListCell.h
//  woeat
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEModelGetMyCardList.h"

#define CARD_CELL_HEIGHT 160

@interface WEBankCardListCell : UITableViewCell

- (void)setData:(WEModelGetMyCardListCardList *)model;
@end
