//
//  WECardNumberInputView.h
//  woeat
//
//  Created by liubin on 17/3/16.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WESelectBankOrInputView;

@interface WECardNumberInputView : UIView
@property(nonatomic, strong) UILabel *cardNameLabel;
@property(nonatomic, strong) UITextField *cardNameField;
//@property(nonatomic, strong) UITextField *personNameField;
@property(nonatomic, strong) UITextField *cardNumberField;
@property(nonatomic, strong) UITextField *monthField;
@property(nonatomic, strong) UITextField *yearField;
@property(nonatomic, strong) UITextField *cvnField;
@property(nonatomic, weak) UIViewController *parentController;
@property(nonatomic, weak) WESelectBankOrInputView *parentView;

-(float)getHeight;
- (void)inputFinish;
//- (NSString *)getCardType;
@end
