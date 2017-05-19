//
//  WEPersonalAddressListCellTableViewCell.h
//  woeat
//
//  Created by liubin on 16/11/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEAddress.h"

@interface WEPersonalAddressListCellTableViewCell : UITableViewCell

- (void)setIsSelected:(BOOL)isSelected;
- (void)setModel:(WEAddress *)model;
@end
