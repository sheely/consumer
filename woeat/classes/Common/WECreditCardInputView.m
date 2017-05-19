//
//  WECreditCardInputView.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WECreditCardInputView.h"
#import "WEDistributeSpaceLabel.h"
#import "WEUtil.h"

@interface WECreditCardInputView()
{
    float _total_height;
    
    UISegmentedControl *_segment;

    UILabel *_label41;
    UILabel *_label42;
    UILabel *_label5;
    UILabel *_label6;
    
    UILabel *_right1;
    UILabel *_right2;
    UILabel *_right3;
    UILabel *_right4;
    UILabel *_right5;
    UILabel *_right6;
}

@end


@implementation WECreditCardInputView

-(instancetype)initWithRecharge:(BOOL)forRecharge
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *superView = self;
        
        UIFont *font = [UIFont systemFontOfSize:14];
        NSArray *array = @[@"信用卡类型", @"持卡人姓名", @"信用卡号码"];
        CGSize size = [WEUtil oneLineSizeForTitle:array[0] font:font];
        size.width += 0.5;
        float middleSpace = 10;
        float vSpace = 15;
        float textFieldOffset = 4;
        
        //信用卡类型
        UILabel *label1 = [UILabel new];
        label1.numberOfLines = 1;
        label1.textAlignment = NSTextAlignmentLeft;
        label1.font = font;
        label1.textColor = [UIColor blackColor];
        label1.text = array[0];
        [superView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.top.equalTo(superView.top);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"VISA", @"MASTERCARD"]];
        NSMutableParagraphStyle* style;
        style = [[NSMutableParagraphStyle alloc] init];
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:12], NSFontAttributeName,
                              [UIColor blackColor], NSForegroundColorAttributeName,
                              style, NSParagraphStyleAttributeName,
                              nil];
        [segment setTitleTextAttributes:attr forState:UIControlStateNormal];
        NSDictionary *attr1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:12], NSFontAttributeName,
                              [UIColor blackColor], NSForegroundColorAttributeName,
                              style, NSParagraphStyleAttributeName,
                              nil];
        [segment setTitleTextAttributes:attr1 forState:UIControlStateSelected];
        segment.tintColor = [UIColor lightGrayColor];
        segment.selectedSegmentIndex = 0;
        [superView addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.right).offset(middleSpace);
            make.centerY.equalTo(label1.centerY);
            make.right.equalTo(superView.right);
            make.height.equalTo(size.height);
        }];
        _segment = segment;
        
        //持卡人姓名
        UILabel *label2 = [UILabel new];
        label2.numberOfLines = 1;
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = font;
        label2.textColor = [UIColor blackColor];
        label2.text = array[1];
        [superView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.left);
            make.top.equalTo(label1.bottom).offset(vSpace);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];

        //持卡人姓名
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectZero];
        nameField.backgroundColor = [UIColor clearColor];
        nameField.delegate = self;
        nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        nameField.autocorrectionType = UITextAutocorrectionTypeNo;
        nameField.font = [UIFont systemFontOfSize:13];
        nameField.textColor = [UIColor blackColor];
        nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameField.layer.cornerRadius=4.0f;
        nameField.layer.masksToBounds=YES;
        nameField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        nameField.layer.borderWidth= 1.0f;
        UIView *tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        nameField.leftView = tmpView1;
        nameField.leftViewMode = UITextFieldViewModeAlways;
        [superView addSubview:nameField];
        [nameField makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right);
            make.left.equalTo(label2.right).offset(middleSpace);
            make.centerY.equalTo(label2.centerY);
            make.height.equalTo(size.height + textFieldOffset);
        }];
        _nameField = nameField;
        
        //信用卡号码
        UILabel *label3 = [UILabel new];
        label3.numberOfLines = 1;
        label3.textAlignment = NSTextAlignmentLeft;
        label3.font = font;
        label3.textColor = [UIColor blackColor];
        label3.text = array[2];
        [superView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.left);
            make.top.equalTo(label2.bottom).offset(vSpace);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        
        //信用卡号码
        UITextField *numberField = [[UITextField alloc] initWithFrame:CGRectZero];
        numberField.backgroundColor = [UIColor clearColor];
        numberField.delegate = self;
        numberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        numberField.autocorrectionType = UITextAutocorrectionTypeNo;
        numberField.font = [UIFont systemFontOfSize:13];
        numberField.textColor = [UIColor blackColor];
        numberField.keyboardType = UIKeyboardTypeNumberPad;
        numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        numberField.layer.cornerRadius=4.0f;
        numberField.layer.masksToBounds=YES;
        numberField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        numberField.layer.borderWidth= 1.0f;
        UIView *tmpView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        numberField.leftView = tmpView2;
        numberField.leftViewMode = UITextFieldViewModeAlways;
        [superView addSubview:numberField];
        [numberField makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right);
            make.left.equalTo(label3.right).offset(middleSpace);
            make.centerY.equalTo(label3.centerY);
            make.height.equalTo(size.height + textFieldOffset);
        }];
        _numberField = numberField;
        
        //过期时间
        WEDistributeSpaceLabel *label4 = [WEDistributeSpaceLabel new];
        label4.numberOfLines = 1;
        label4.textAlignment = NSTextAlignmentLeft;
        label4.font = font;
        label4.textColor = [UIColor blackColor];
        [label4 setDistributeText:@"过期时间" width:size.width];
        [superView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label3.left);
            make.top.equalTo(label3.bottom).offset(vSpace);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        
        //月
        UITextField *monthField = [[UITextField alloc] initWithFrame:CGRectZero];
        monthField.backgroundColor = [UIColor clearColor];
        monthField.delegate = self;
        monthField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        monthField.autocorrectionType = UITextAutocorrectionTypeNo;
        monthField.font = [UIFont systemFontOfSize:13];
        monthField.textColor = [UIColor blackColor];
        monthField.keyboardType = UIKeyboardTypeNumberPad;
        monthField.clearButtonMode = UITextFieldViewModeNever;
        monthField.layer.cornerRadius=4.0f;
        monthField.layer.masksToBounds=YES;
        monthField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        monthField.layer.borderWidth= 1.0f;
        UIView *tmpView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        monthField.leftView = tmpView3;
        monthField.leftViewMode = UITextFieldViewModeAlways;
        [superView addSubview:monthField];
        [monthField makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(40);
            make.left.equalTo(label4.right).offset(middleSpace);
            make.centerY.equalTo(label4.centerY);
            make.height.equalTo(size.height + textFieldOffset);
        }];
        _monthField = monthField;
        
        //MM
        UILabel *label41 = [UILabel new];
        label41.numberOfLines = 1;
        label41.textAlignment = NSTextAlignmentLeft;
        label41.font = font;
        label41.textColor = [UIColor blackColor];
        label41.text = @"MM";
        [superView addSubview:label41];
        [label41 sizeToFit];
        [label41 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(monthField.right).offset(middleSpace);
            make.centerY.equalTo(label4.centerY);
        }];
        _label41 = label41;
        
        //年
        UITextField *yearField = [[UITextField alloc] initWithFrame:CGRectZero];
        yearField.backgroundColor = [UIColor clearColor];
        yearField.delegate = self;
        yearField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        yearField.autocorrectionType = UITextAutocorrectionTypeNo;
        yearField.font = [UIFont systemFontOfSize:13];
        yearField.textColor = [UIColor blackColor];
        yearField.keyboardType = UIKeyboardTypeNumberPad;
        yearField.clearButtonMode = UITextFieldViewModeNever;
        yearField.layer.cornerRadius=4.0f;
        yearField.layer.masksToBounds=YES;
        yearField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        yearField.layer.borderWidth= 1.0f;
        UIView *tmpView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        yearField.leftView = tmpView4;
        yearField.leftViewMode = UITextFieldViewModeAlways;
        [superView addSubview:yearField];
        [yearField makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60);
            make.left.equalTo(label41.right).offset(middleSpace);
            make.centerY.equalTo(label41.centerY);
            make.height.equalTo(size.height + textFieldOffset);
        }];
        _yearField = yearField;
        
        //YY
        UILabel *label42 = [UILabel new];
        label42.numberOfLines = 1;
        label42.textAlignment = NSTextAlignmentLeft;
        label42.font = font;
        label42.textColor = [UIColor blackColor];
        label42.text = @"YY";
        [superView addSubview:label42];
        [label42 sizeToFit];
        [label42 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(yearField.right).offset(middleSpace);
            make.centerY.equalTo(label4.centerY);
        }];
        _label42 = label42;
        
        //安全码
        UILabel *label5 = [UILabel new];
        label5.numberOfLines = 1;
        label5.textAlignment = NSTextAlignmentLeft;
        label5.font = font;
        label5.textColor = [UIColor blackColor];
        label5.text = @"安全码";
        [superView addSubview:label5];
        [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label4.left);
            make.top.equalTo(label4.bottom).offset(vSpace);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        _label5 = label5;
        
        //安全码
        UITextField *cvnField = [[UITextField alloc] initWithFrame:CGRectZero];
        cvnField.backgroundColor = [UIColor clearColor];
        cvnField.delegate = self;
        cvnField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cvnField.autocorrectionType = UITextAutocorrectionTypeNo;
        cvnField.font = [UIFont systemFontOfSize:13];
        cvnField.textColor = [UIColor blackColor];
        cvnField.keyboardType = UIKeyboardTypeNumberPad;
        cvnField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cvnField.layer.cornerRadius=4.0f;
        cvnField.layer.masksToBounds=YES;
        cvnField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cvnField.layer.borderWidth= 1.0f;
        UIView *tmpView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        cvnField.leftView = tmpView7;
        cvnField.leftViewMode = UITextFieldViewModeAlways;
        [superView addSubview:cvnField];
        [cvnField makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right);
            make.left.equalTo(label5.right).offset(middleSpace);
            make.centerY.equalTo(label5.centerY);
            make.height.equalTo(size.height + textFieldOffset);
        }];
        _cvnField = cvnField;

        _total_height = size.height * 5 + vSpace * 4 + textFieldOffset;
        
        if (forRecharge) {
            //充值金额
            UILabel *label6 = [UILabel new];
            label6.numberOfLines = 1;
            label6.textAlignment = NSTextAlignmentLeft;
            label6.font = font;
            label6.textColor = [UIColor blackColor];
            label6.text = @"充值金额";
            [superView addSubview:label6];
            [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label4.left);
                make.top.equalTo(label5.bottom).offset(vSpace);
                make.width.equalTo(size.width);
                make.height.equalTo(size.height);
            }];
            _label6 = label6;
            
            //充值金额
            UITextField *valueField = [[UITextField alloc] initWithFrame:CGRectZero];
            valueField.backgroundColor = [UIColor clearColor];
            valueField.delegate = self;
            valueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            valueField.autocorrectionType = UITextAutocorrectionTypeNo;
            valueField.font = [UIFont systemFontOfSize:13];
            valueField.textColor = [UIColor blackColor];
            valueField.keyboardType = UIKeyboardTypeNumberPad;
            valueField.clearButtonMode = UITextFieldViewModeWhileEditing;
            valueField.layer.cornerRadius=4.0f;
            valueField.layer.masksToBounds=YES;
            valueField.layer.borderColor=[UIColor lightGrayColor].CGColor;
            valueField.layer.borderWidth= 1.0f;
            UIView *tmpView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            valueField.leftView = tmpView3;
            valueField.leftViewMode = UITextFieldViewModeAlways;
            [superView addSubview:valueField];
            [valueField makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(superView.right);
                make.left.equalTo(label6.right).offset(middleSpace);
                make.centerY.equalTo(label6.centerY);
                make.height.equalTo(size.height + textFieldOffset);
            }];
            _valueField = valueField;

            _total_height = size.height * 6 + vSpace * 5 + textFieldOffset;
        }
        
        
        //label1
        UIColor *rightColor = UICOLOR(50,50,50);
        UILabel *right1 = [UILabel new];
        right1.numberOfLines = 1;
        right1.textAlignment = NSTextAlignmentLeft;
        right1.font = font;
        right1.textColor = rightColor;
        [superView addSubview:right1];
        [right1 sizeToFit];
        [right1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.right).offset(middleSpace);
            make.centerY.equalTo(label1.centerY);
        }];
        right1.hidden = YES;
        _right1 = right1;
        
        //label2
        UILabel *right2 = [UILabel new];
        right2.numberOfLines = 1;
        right2.textAlignment = NSTextAlignmentLeft;
        right2.font = font;
        right2.textColor = rightColor;
        [superView addSubview:right2];
        [right2 sizeToFit];
        [right2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(right1.left);
            make.centerY.equalTo(label2.centerY);
        }];
        right2.hidden = YES;
        _right2 = right2;
        
        //label3
        UILabel *right3 = [UILabel new];
        right3.numberOfLines = 1;
        right3.textAlignment = NSTextAlignmentLeft;
        right3.font = font;
        right3.textColor = rightColor;
        [superView addSubview:right3];
        [right3 sizeToFit];
        [right3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(right1.left);
            make.centerY.equalTo(label3.centerY);
        }];
        right3.hidden = YES;
        _right3 = right3;
        
        //label4
        UILabel *right4 = [UILabel new];
        right4.numberOfLines = 1;
        right4.textAlignment = NSTextAlignmentLeft;
        right4.font = font;
        right4.textColor = rightColor;
        [superView addSubview:right4];
        [right4 sizeToFit];
        [right4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(right1.left);
            make.centerY.equalTo(label4.centerY);
        }];
        right4.hidden = YES;
        _right4 = right4;
        
        //label5
        UILabel *right5 = [UILabel new];
        right5.numberOfLines = 1;
        right5.textAlignment = NSTextAlignmentLeft;
        right5.font = font;
        right5.textColor = rightColor;
        [superView addSubview:right5];
        [right5 sizeToFit];
        [right5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(right1.left);
            make.centerY.equalTo(_label5.centerY);
        }];
        right5.hidden = YES;
        _right5 = right5;
        
        if (forRecharge) {
            //label6
            UILabel *right6 = [UILabel new];
            right6.numberOfLines = 1;
            right6.textAlignment = NSTextAlignmentLeft;
            right6.font = font;
            right6.textColor = rightColor;
            [superView addSubview:right6];
            [right6 sizeToFit];
            [right6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(right1.left);
                make.centerY.equalTo(_label6.centerY);
            }];
            right6.hidden = YES;
            _right6 = right6;
        }
    }
    return self;
}

- (float)getHeight
{
    return _total_height;
}

- (NSString *)getCardType
{
    NSString *card = nil;
    if (_segment.selectedSegmentIndex == 0) {
        card = @"VISA";
    } else {
        card = @"MASTERCARD";
    }
    return card;
}

- (void)inputFinish
{
    _segment.hidden = YES;
    _nameField.hidden = YES;
    _numberField.hidden = YES;
    _monthField.hidden = YES;
    _label41.hidden = YES;
    _yearField.hidden = YES;
    _label42.hidden = YES;
    _cvnField.hidden = YES;
    _valueField.hidden = YES;

    _right1.hidden = NO;
    _right2.hidden = NO;
    _right3.hidden = NO;
    _right4.hidden = NO;
    _right5.hidden = NO;
    _right6.hidden = NO;
    _right1.text = [self getCardType];
    _right2.text = _nameField.text;
    _right3.text = _numberField.text;
    _right4.text = [NSString stringWithFormat:@"%@ / %@", _monthField.text, _yearField.text];
    _right5.text = _cvnField.text;
    _right6.text = _valueField.text;
}


@end
