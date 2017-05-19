//
//  WESelectBankOrInputView.h
//  woeat
//
//  Created by liubin on 17/3/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WECardNumberInputView;
@class WEBankCardListView;

@interface WESelectBankOrInputView : UIView

@property(nonatomic, strong) MASConstraint *heightConstraint;
@property(nonatomic, weak) WECardNumberInputView *inputNumberView;
@property(nonatomic, weak) WEBankCardListView *cardListView;
@property(nonatomic, strong) UITextField *rechargeField;

- (instancetype)initWithRecharge:(BOOL)recharge;
- (float)getHeight;

- (void)heightChanged;

- (BOOL)isSelectSaveCard;
- (NSString *)getSelectedCardId;

- (void)setEditFinished:(BOOL)finished;

- (void)setParentViewController:(UIViewController *)viewController;
@end
