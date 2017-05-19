//
//  WECardNumberInputView.m
//  woeat
//
//  Created by liubin on 17/3/16.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WECardNumberInputView.h"
#import "WEUtil.h"
#import "WELeftTextField.h"
//#import "WECardTypeCheckView.h"
#import "CardIO.h"
#import "UmengStat.h"

@interface WECardNumberInputView()
{
    float _total_height;
}

@end


@implementation WECardNumberInputView

- (void)addView
{
    UIView *superView = self;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    float vSpace = 15;
    float leftX = 0;
    float textFieldHeight = 30;
    //self.backgroundColor = [UIColor blueColor];
    UIColor *boarderColor = UICOLOR(0xD7, 0xD7, 0xD7);
    
    UIButton *topBg = [UIButton new];
    topBg.backgroundColor = DARK_ORANGE_COLOR;
    topBg.layer.cornerRadius = 10;
    topBg.layer.masksToBounds = YES;
    topBg.clipsToBounds = YES;
    [topBg addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.top.equalTo(superView.top).offset(vSpace);
        make.right.equalTo(superView.right).offset(-leftX);
        make.height.equalTo(textFieldHeight);
    }];
    
    UIImageView *topLogo = [UIImageView new];
    topLogo.image = [UIImage imageNamed:@"card_scan_icon"];
    [superView addSubview:topLogo];
    [topLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBg.left).offset([WEUtil getScreenWidth]*0.12);
        make.centerY.equalTo(topBg.centerY);
        make.height.equalTo(topBg.height).offset(-8);
        make.width.equalTo(topLogo.height);
    }];
    
    UILabel *topLabel = [UILabel new];
    topLabel.numberOfLines = 1;
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.font = [UIFont systemFontOfSize:12];;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"卡号输入太麻烦？试试扫一下";
    [superView addSubview:topLabel];
    [topLabel sizeToFit];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLogo.right).offset(10);
        make.centerY.equalTo(topBg.centerY);
    }];

    //银行卡名称
    UILabel *label1 = [UILabel new];
    label1.numberOfLines = 1;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = font;
    label1.textColor = [UIColor blackColor];
    label1.text = @"银行卡名称";
    [superView addSubview:label1];
    [label1 sizeToFit];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.top.equalTo(topBg.bottom).offset(vSpace);
    }];
    _cardNameLabel = label1;

    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectZero];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.delegate = self;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.font = [UIFont systemFontOfSize:13];
    nameField.textColor = [UIColor blackColor];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.layer.cornerRadius=5.0f;
    nameField.layer.masksToBounds=YES;
    nameField.layer.borderColor= boarderColor.CGColor;
    nameField.layer.borderWidth= 0.5;
    UIView *tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    nameField.leftView = tmpView1;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    [superView addSubview:nameField];
    [nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.right.equalTo(superView.right).offset(-leftX);
        make.top.equalTo(label1.bottom).offset(3);
        make.height.equalTo(textFieldHeight);
    }];
    _cardNameField = nameField;

    
//    //持卡人姓名
//    label1 = [UILabel new];
//    label1.numberOfLines = 1;
//    label1.textAlignment = NSTextAlignmentLeft;
//    label1.font = font;
//    label1.textColor = [UIColor blackColor];
//    label1.text = @"持卡人姓名";
//    [superView addSubview:label1];
//    [label1 sizeToFit];
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(leftX);
//        make.top.equalTo(_cardNameField.bottom).offset(3);
//    }];
//    
//    nameField = [[UITextField alloc] initWithFrame:CGRectZero];
//    nameField.backgroundColor = [UIColor clearColor];
//    nameField.delegate = self;
//    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
//    nameField.font = [UIFont systemFontOfSize:13];
//    nameField.textColor = [UIColor blackColor];
//    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    nameField.layer.cornerRadius=5.0f;
//    nameField.layer.masksToBounds=YES;
//    nameField.layer.borderColor= UICOLOR(0xE7, 0xE7, 0xE7).CGColor;
//    nameField.layer.borderWidth= 0.5;
//    tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
//    nameField.leftView = tmpView1;
//    nameField.leftViewMode = UITextFieldViewModeAlways;
//    [superView addSubview:nameField];
//    [nameField makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(leftX);
//        make.right.equalTo(superView.right).offset(-leftX);
//        make.top.equalTo(label1.bottom).offset(3);
//        make.height.equalTo(textFieldHeight);
//    }];
//    _personNameField = nameField;
    
    //银行卡号码
    label1 = [UILabel new];
    label1.numberOfLines = 1;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = font;
    label1.textColor = [UIColor blackColor];
    label1.text = @"银行卡号码";
    [superView addSubview:label1];
    [label1 sizeToFit];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.top.equalTo(_cardNameField.bottom).offset(3);
    }];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectZero];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.delegate = self;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.font = [UIFont systemFontOfSize:13];
    nameField.textColor = [UIColor blackColor];
    nameField.keyboardType = UIKeyboardTypeNumberPad;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.layer.cornerRadius=5.0f;
    nameField.layer.masksToBounds=YES;
    nameField.layer.borderColor= boarderColor.CGColor;
    nameField.layer.borderWidth= 0.5;
    tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    nameField.leftView = tmpView1;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    [superView addSubview:nameField];
    [nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.right.equalTo(superView.right).offset(-leftX);
        make.top.equalTo(label1.bottom).offset(3);
        make.height.equalTo(textFieldHeight);
    }];
    _cardNumberField = nameField;
    
    //有效期至
    label1 = [UILabel new];
    label1.numberOfLines = 1;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = font;
    label1.textColor = [UIColor blackColor];
    label1.text = @"有效期至";
    [superView addSubview:label1];
    [label1 sizeToFit];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.top.equalTo(_cardNumberField.bottom).offset(3);
    }];
    
    nameField = [[WELeftTextField alloc] initWithLeftText:@"MM"];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.delegate = self;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.font = [UIFont systemFontOfSize:13];
    nameField.keyboardType = UIKeyboardTypeNumberPad;
    nameField.textColor = [UIColor blackColor];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.layer.cornerRadius=5.0f;
    nameField.layer.masksToBounds=YES;
    nameField.layer.borderColor= boarderColor.CGColor;
    nameField.layer.borderWidth= 0.5;
    [superView addSubview:nameField];
    [nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.width.equalTo([WEUtil getScreenWidth]*0.4);
        make.top.equalTo(label1.bottom).offset(3);
        make.height.equalTo(textFieldHeight);
    }];
    _monthField = nameField;
    
    nameField = [[WELeftTextField alloc] initWithLeftText:@"YY"];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.delegate = self;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.font = [UIFont systemFontOfSize:13];
    nameField.keyboardType = UIKeyboardTypeNumberPad;
    nameField.textColor = [UIColor blackColor];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.layer.cornerRadius=5.0f;
    nameField.layer.masksToBounds=YES;
    nameField.layer.borderColor= boarderColor.CGColor;
    nameField.layer.borderWidth= 0.5;
    [superView addSubview:nameField];
    [nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_monthField.right).offset(15);
        make.width.equalTo([WEUtil getScreenWidth]*0.4);
        make.top.equalTo(_monthField.top);
        make.height.equalTo(textFieldHeight);
    }];
    _yearField = nameField;
    
    //CVN
    label1 = [UILabel new];
    label1.numberOfLines = 1;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = font;
    label1.textColor = [UIColor blackColor];
    label1.text = @"CVN";
    [superView addSubview:label1];
    [label1 sizeToFit];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.top.equalTo(_yearField.bottom).offset(3);
    }];
    
    nameField = [UITextField new];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.delegate = self;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.font = [UIFont systemFontOfSize:13];
    nameField.keyboardType = UIKeyboardTypeNumberPad;
    nameField.textColor = [UIColor blackColor];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.layer.cornerRadius=5.0f;
    nameField.layer.masksToBounds=YES;
    nameField.layer.borderColor= boarderColor.CGColor;
    nameField.layer.borderWidth= 0.5;
    tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    nameField.leftView = tmpView1;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    [superView addSubview:nameField];
    [nameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(leftX);
        make.width.equalTo([WEUtil getScreenWidth]*0.4);
        make.top.equalTo(label1.bottom).offset(3);
        make.height.equalTo(textFieldHeight);
    }];
    _cvnField = nameField;

//    //类型
//    label1 = [UILabel new];
//    label1.numberOfLines = 1;
//    label1.textAlignment = NSTextAlignmentLeft;
//    label1.font = font;
//    label1.textColor = [UIColor blackColor];
//    label1.text = @"类型";
//    [superView addSubview:label1];
//    [label1 sizeToFit];
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(leftX);
//        make.top.equalTo(_cvnField.bottom).offset(3);
//    }];
    
//    WECardTypeCheckView *checkView = [WECardTypeCheckView new];
//    [superView addSubview:checkView];
//    [checkView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(leftX);
//        make.right.equalTo(superView.right).offset(-leftX);
//        make.top.equalTo(label1.bottom).offset(10);
//        make.height.equalTo([checkView getHeight]);
//    }];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addView];
        [CardIOUtilities preload];
    }
    return self;
}

- (float)getHeight
{
    return 270;
}

//- (NSString *)getCardType
//{
//    return @"";
//}

- (void)topButtonTapped:(UIButton *)button
{
    if (!_parentController) {
        return;
    }
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [_parentController presentViewController:scanViewController animated:YES completion:nil];
    [UmengStat pageEnter:UMENG_STAT_PAGE_BANK_CARD_SCAN];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [_parentController dismissViewControllerAnimated:YES completion:nil];
    
    if (info.cardNumber.length) {
        _cardNumberField.text = info.cardNumber;
    }
    if (info.expiryMonth) {
        _monthField.text = [NSString stringWithFormat:@"%ld", info.expiryMonth];
    }
    if (info.expiryYear) {
        _yearField.text = [NSString stringWithFormat:@"%ld", info.expiryYear];
    }
    if (info.cvv.length) {
        _cvnField.text = info.cvv;
    }
    [UmengStat pageLeave:UMENG_STAT_PAGE_BANK_CARD_SCAN];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [_parentController dismissViewControllerAnimated:YES completion:nil];
    [UmengStat pageLeave:UMENG_STAT_PAGE_BANK_CARD_SCAN];
}



@end
