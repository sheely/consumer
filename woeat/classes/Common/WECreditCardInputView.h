//
//  WECreditCardInputView.h
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WECreditCardInputView : UIView

@property(nonatomic, strong) UITextField *nameField;
@property(nonatomic, strong) UITextField *numberField;
@property(nonatomic, strong) UITextField *monthField;
@property(nonatomic, strong) UITextField *yearField;
@property(nonatomic, strong) UITextField *cvnField;
@property(nonatomic, strong) UITextField *valueField;

-(instancetype)initWithRecharge:(BOOL)forRecharge;
-(float)getHeight;
- (void)inputFinish;
- (NSString *)getCardType;
@end
