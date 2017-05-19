//
//  WESelectBankOrInputView.m
//  woeat
//
//  Created by liubin on 17/3/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WESelectBankOrInputView.h"
#import "HMSegmentedControl.h"
#import "WEUtil.h"
#import "WEBankCardListView.h"
#import "WECardNumberInputView.h"
#import "WEPayConfirmView.h"
#import "WEModelGetMyCardList.h"

@interface WESelectBankOrInputView()
{
    BOOL _hasRecharge;
    
    HMSegmentedControl *_segmentedControl;
    float _originHeight;
    
    UIView *_cardInputContainer;
    WEPayConfirmView *_confirmView;
}

@end


@implementation WESelectBankOrInputView

- (void)addView
{
    _originHeight = 0;
    UIView *superView = self;
    UIView *cardInputContainer = [UIView new];
    [superView addSubview:cardInputContainer];
    [cardInputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom);
    }];
    _cardInputContainer = cardInputContainer;
    superView = cardInputContainer;
    
    float offsetX = 0;
    float iconScale = 0.3;
    UIView *topView = nil;
    
    if (_hasRecharge) {
        UIView *rechargeView = [UIView new];
        rechargeView.backgroundColor = [UIColor clearColor];
        [superView addSubview:rechargeView];
        [rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top);
            make.height.equalTo(70);
        }];
        _originHeight += 70;
        
        superView = rechargeView;
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"icon_recharge"];
        [superView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(5);
            make.top.equalTo(superView.top);
            make.height.equalTo(icon.image.size.height*iconScale);
            make.width.equalTo(icon.image.size.width*iconScale);
        }];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        [superView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.right).offset(5);
            make.centerY.equalTo(icon.centerY);
        }];
        label.text = @"充值金额";

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
        nameField.layer.borderColor= UICOLOR(0xD7, 0xD7, 0xD7).CGColor;
        nameField.layer.borderWidth= 0.5;
        nameField.keyboardType = UIKeyboardTypeDecimalPad;
        nameField.placeholder = @"填写充值金额";
        UIView *tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        nameField.leftView = tmpView1;
        nameField.leftViewMode = UITextFieldViewModeAlways;
        [superView addSubview:nameField];
        [nameField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(icon.bottom).offset(8);
            make.height.equalTo(30);
        }];
        _rechargeField = nameField;
        
        topView = rechargeView;
    }

    superView = cardInputContainer;
    UIImageView *icon = [UIImageView new];
    icon.image = [UIImage imageNamed:@"icon_select_card"];
    [superView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX + 5);
        if (topView) {
            make.top.equalTo(topView.bottom).offset(0);
        } else {
             make.top.equalTo(superView.top);
        }
        make.height.equalTo(icon.image.size.height*iconScale);
        make.width.equalTo(icon.image.size.width*iconScale);
    }];
    _originHeight += icon.image.size.height*iconScale;
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:13];
    [superView addSubview:label];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.right).offset(5);
        make.centerY.equalTo(icon.centerY);
    }];
    label.text = @"选择银行卡";
    
    float segmentHeight = 35;
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:
                                             @[@"已添加的银行卡",
                                               @"填写卡号"]];
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = UICOLOR(0x9c, 0x74, 0x77);
    segmentedControl.verticalDividerWidth = 1.0f;
    segmentedControl.borderType = HMSegmentedControlBorderTypeBottom;
    segmentedControl.borderColor = UICOLOR(0x9c, 0x74, 0x77);
    segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.selectionIndicatorColor = UICOLOR(0xb8, 0x4a, 0x44);
    segmentedControl.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], segmentHeight);
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [superView addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(label.bottom).offset(10);
        make.height.equalTo(segmentHeight);
    }];
    _segmentedControl = segmentedControl;
    _originHeight += 10 + segmentHeight;
    
    WEBankCardListView *cardListView = [WEBankCardListView new];
    cardListView.backgroundColor = [UIColor clearColor];
    [superView addSubview:cardListView];
    [cardListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(segmentedControl.bottom).offset(1);
        //make.height.equalTo([cardListView getHeight]);
        make.bottom.equalTo(superView.bottom);
    }];
    cardListView.hidden = NO;
    _cardListView = cardListView;
    _cardListView.parentView = self;
                                          
    WECardNumberInputView *inputNumberView = [WECardNumberInputView new];
    inputNumberView.cardNameLabel.text = @"持卡人姓名";
    [superView addSubview:inputNumberView];
    [inputNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(segmentedControl.bottom);
        //make.height.equalTo([cardListView getHeight]);
        make.bottom.equalTo(superView.bottom);
    }];
    _inputNumberView = inputNumberView;
    _inputNumberView.hidden = YES;
    _inputNumberView.parentView = self;
    
    superView = self;
    WEPayConfirmView *confirmView = [[WEPayConfirmView alloc] initWithRecharge:_hasRecharge];
    [superView addSubview:confirmView];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom);
    }];
    _confirmView = confirmView;
    _confirmView.hidden = YES;
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    int index = sender.selectedSegmentIndex;
//    for(UIView *v in [self subviews]) {
//        [v removeFromSuperview];
//    }
//    [self addView];
    
    
    if (index == 0) {
        _cardListView.hidden = NO;
        _inputNumberView.hidden = YES;
    } else {
        _cardListView.hidden = YES;
        _inputNumberView.hidden = NO;
    }
    [self heightChanged];
}


- (instancetype)initWithRecharge:(BOOL)recharge
{
    self = [super init];
    if (self) {
        _hasRecharge = recharge;
        [self addView];
        [self heightChanged];
    }
    return self;
}




- (float)getHeight
{
    float height = 0;
    if (!_cardInputContainer.hidden) {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            height = [_cardListView getHeight];
        } else {
            height = [_inputNumberView getHeight];
        }
        height += _originHeight;
    } else {
        height = [_confirmView getHeight];
    }
    
    return  + height;
}

- (void)tmp
{
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

- (void)heightChanged
{
    if (_heightConstraint) {
        _heightConstraint.equalTo(self.getHeight);
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
//        [UIView animateWithDuration:0.25 animations:^{
//             [self.superview setNeedsLayout];
//        }];
        [self performSelector:@selector(tmp) withObject:nil afterDelay:1];
        
    }
}

- (NSString *)getSelectedCardId
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return _cardListView.getSelectedCardModel.Id;
    } else {
        return nil;
    }
}

- (BOOL)isSelectSaveCard
{
    return (_segmentedControl.selectedSegmentIndex == 0);
}

- (void)setEditFinished:(BOOL)finished
{
    if (finished) {
        _cardInputContainer.hidden = YES;
        _confirmView.hidden = NO;
        if (_segmentedControl.selectedSegmentIndex == 0) {
            WEModelGetMyCardListCardList *model = _cardListView.getSelectedCardModel;
            _confirmView.right1.text = _rechargeField.text;
            _confirmView.right2.text = model.Name;
            _confirmView.right3.text = [NSString stringWithFormat:@"XXXX XXXX XXXX %@", model.MaskedCardNumber];
            _confirmView.right4.text = [NSString stringWithFormat:@"%d / %d", model.ExpirationMonth, model.ExpirationYear];
            
        } else {
            _confirmView.right1.text = _rechargeField.text;
            _confirmView.right2.text = _inputNumberView.cardNameField.text;
            _confirmView.right3.text = _inputNumberView.cardNumberField.text;
            _confirmView.right4.text = [NSString stringWithFormat:@"%@ / %@", _inputNumberView.monthField.text,
                                        _inputNumberView.yearField.text];
        }
    
    } else {
        _cardInputContainer.hidden = NO;
        _confirmView.hidden = YES;
    }
    [self heightChanged];
}

- (void)setParentViewController:(UIViewController *)viewController
{
    _inputNumberView.parentController = viewController;
}

@end
