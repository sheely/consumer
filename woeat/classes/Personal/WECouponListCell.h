//
//  WECouponListCell.h
//  woeat
//
//  Created by liubin on 16/11/30.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEModelGetMyRedeemableCouponUserCouponList;
@interface WECouponListCell : UITableViewCell


- (void)setIsSelected:(BOOL)isSelected;
-(void)setModel:(WEModelGetMyRedeemableCouponUserCouponList *)model;
@end
