//
//  WEBankCardListView.h
//  woeat
//
//  Created by liubin on 17/3/18.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WESelectBankOrInputView.h"

@class WEModelGetMyCardListCardList;

@interface WEBankCardListView : UIView

@property(nonatomic, weak) WESelectBankOrInputView *parentView;
@property(nonatomic, strong) UILabel *emptyLabel;

- (float)getHeight;
- (WEModelGetMyCardListCardList *)getSelectedCardModel;
@end
