//
//  WERechargeViewController.m
//  woeat
//
//  Created by liubin on 16/12/21.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WERechargeViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "WEOrderDishListView.h"
#import "WETwoColumnListView.h"
#import "WECreditCardInputView.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "MBProgressHUD.h"
#import "WEModelOrder.h"
#import "WEOrderPayViewController.h"
#import "WEModelCommon.h"
#import "WEShoppingCartManager.h"
#import "UmengStat.h"
#import "WESelectBankOrInputView.h"
#import "WECardNumberInputView.h"

@interface WERechargeViewController ()
{
    UIScrollView *_scrollView;
    
    WEOrderDishListView *_dishListView;
    MASConstraint *_dishListViewHeightConstraint;
    
    UIButton *_payButton;
    UIButton *_confirmPayButton;
    UIButton *_returnButton;
    
    //WECreditCardInputView *_creditCardView;
    WETwoColumnListView *_orderList;
    WESelectBankOrInputView *_selectCardView;
    MASConstraint *_cardHegihtContentConstraint;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation WERechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.returnKeyHandler = nil;
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDefault;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"充值";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    //scroll
    UIScrollView *scrollView = [UIScrollView new];
    [superView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _scrollView = scrollView;
    
    //content
    superView = scrollView;
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [superView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.top);
        make.left.equalTo(scrollView.left);
        make.right.equalTo(scrollView.right);
        make.bottom.equalTo(scrollView.bottom);
        make.width.equalTo([WEUtil getScreenWidth]);
    }];
    
    superView = contentView;
    
    
    WETwoColumnListView *orderList = [WETwoColumnListView new];
    orderList.font = [UIFont systemFontOfSize:14];
    orderList.color = [UIColor blackColor];
    orderList.middleSpace = 20;
    orderList.maxWidth = 170;
    orderList.vSpace = 8;
    orderList.vSpaceLine = 6;
    NSString *totalValue = [NSString stringWithFormat:@"$%.2f", _order.TotalValue];
    float coupon = 0;
    for(WEModelOrderLines *item in _order.Lines) {
        if ([item.LineType isEqualToString:@"COUPON"]) {
            coupon += item.UnitPrice * item.Quantity;
        }
    }
    NSString *couponValue = [NSString stringWithFormat:@"-$%.2f", coupon];
    NSString *payValue = [NSString stringWithFormat:@"$%.2f", _order.PayableValue];
    NSString *balanceValue = [NSString stringWithFormat:@"$%.2f", _currentBalance];
    [orderList setUpLeftText:@[@"订单金额", @"优惠券", @"应付金额", @"当前余额"]
                   rightText:@[totalValue, couponValue, payValue, balanceValue]];
    //[orderList setUpLeftText:@[@"订单金额", @"优惠券", @"应付金额"] rightText:@[@"$100.00", @"-$10.00", @"85.00"]];
    [superView addSubview:orderList];
    [orderList makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(20);
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo(orderList.maxWidth);
        make.height.equalTo(orderList.getHeight);
    }];
    _orderList = orderList;
    
//    WECreditCardInputView *creditCardView = [[WECreditCardInputView alloc] initWithRecharge:YES];
//    [superView addSubview:creditCardView];
//    [creditCardView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(orderList.bottom).offset(20);
//        make.left.equalTo(superView.left).offset(25);
//        make.right.equalTo(superView.right).offset(-25);
//        make.height.equalTo(creditCardView.getHeight);
//        
//    }];
//    _creditCardView = creditCardView;
    WESelectBankOrInputView *selectCardView = [[WESelectBankOrInputView alloc] initWithRecharge:YES];
    [selectCardView setParentViewController:self];
    [superView addSubview:selectCardView];
    [selectCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderList.bottom).offset(20);
        make.left.equalTo(superView.left).offset(25);
        make.right.equalTo(superView.right).offset(-25);
        _cardHegihtContentConstraint = make.height.equalTo(selectCardView.getHeight);
        selectCardView.heightConstraint = _cardHegihtContentConstraint;
    }];
    _selectCardView = selectCardView;
    
    UIButton *payButton = [UIButton new];
    payButton.backgroundColor = DARK_ORANGE_COLOR;
    payButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    payButton.layer.cornerRadius=8.0f;
    payButton.layer.masksToBounds=YES;
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setTitle:@"充值" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:payButton];
    [payButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(_selectCardView.bottom).offset(15);
        make.height.equalTo(25);
        make.width.equalTo(150);
    }];
    _payButton = payButton;
    
    UIButton *returnButton = [UIButton new];
    returnButton.backgroundColor = UICOLOR(0xcd, 0xcd, 0xcd);
    returnButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    returnButton.layer.cornerRadius=4.0f;
    returnButton.layer.masksToBounds=YES;
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:returnButton];
    [returnButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectCardView.left).offset(10);
        make.top.equalTo(selectCardView.bottom).offset(15);
        make.height.equalTo(25);
        make.width.equalTo([WEUtil getScreenWidth]*0.35);
    }];
    _returnButton = returnButton;
    _returnButton.hidden = YES;
    
    UIButton *confirmPayButton = [UIButton new];
    confirmPayButton.backgroundColor = DARK_ORANGE_COLOR;
    confirmPayButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    confirmPayButton.layer.cornerRadius=4.0f;
    confirmPayButton.layer.masksToBounds=YES;
    [confirmPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmPayButton setTitle:@"确认充值" forState:UIControlStateNormal];
    [confirmPayButton addTarget:self action:@selector(confirmPayButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:confirmPayButton];
    [confirmPayButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(returnButton.right).offset(10);
        make.top.equalTo(selectCardView.bottom).offset(15);
        make.height.equalTo(25);
        make.width.equalTo([WEUtil getScreenWidth]*0.35);
    }];
    _confirmPayButton = confirmPayButton;
    _confirmPayButton.hidden = YES;
    
    WEOrderDishListView *dishListView = [WEOrderDishListView new];
    [superView addSubview:dishListView];
    [dishListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payButton.bottom).offset(40);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _dishListViewHeightConstraint = make.height.equalTo(200);
        make.bottom.equalTo(superView.bottom).offset(-30);
    }];
    _dishListView = dishListView;
    _dishListView.kitchenInfo = _kitchenInfo;
    _dishListView.order = _order;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengStat pageEnter:UMENG_STAT_PAGE_BALANCE_CHARGE];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTableHeight];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UmengStat pageLeave:UMENG_STAT_PAGE_BALANCE_CHARGE];
}


- (void)updateTableHeight
{
    _dishListViewHeightConstraint.equalTo( _dishListView.tableView.contentSize.height );
}


- (void)showErrorHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = text;
    [hud show:YES];
    
    [hud hide:YES afterDelay:2];
}


- (void)returnButtonTapped:(UIButton *)button
{
    [_selectCardView setEditFinished:NO];
    _payButton.hidden = NO;
    _returnButton.hidden = YES;
    _confirmPayButton.hidden = YES;
    
}

- (void)confirmPayButtonTapped:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在充值，请稍后...";
    [hud show:YES];
    
    NSString *cardId = _selectCardView.getSelectedCardId;
    if ([_selectCardView isSelectSaveCard]) {
        if (cardId.length) {
            [WENetUtil RechargeBySavedCardWithCardId:cardId
                                               Value:@""
                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                 JSONModelError* error = nil;
                                                 NSDictionary *dict = (NSDictionary *)responseObject;
                                                 WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                                 if (error) {
                                                     NSLog(@"error %@", error);
                                                 }
                                                 if (common.IsSuccessful) {
                                                     hud.labelText = @"充值成功";
                                                     [hud hide:YES afterDelay:1.0];
                                                     hud.delegate = self;
                                                     
                                                 } else {
                                                     hud.labelText = common.ResponseMessage;
                                                     [hud hide:YES afterDelay:1.5];
                                                 }
                                             } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                 NSLog(@"failure %@", errorMsg);
                                                 hud.labelText = errorMsg;
                                                 [hud hide:YES afterDelay:1.5];
                                             }];
            
            
        } else {
            NSLog(@"no save bank card");
        }
        
    } else {
        WECardNumberInputView *inputView = _selectCardView.inputNumberView;
        
        [WENetUtil RechargeWithCardType:@""
                         CardHolderName:inputView.cardNameField.text
                             CardNumber:inputView.cardNumberField.text
                               ExpiryMM:inputView.monthField.text
                               ExpiryYY:inputView.yearField.text
                                    CVN:inputView.cvnField.text
                                  Value:@""
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    JSONModelError* error = nil;
                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                    WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                    if (error) {
                                        NSLog(@"error %@", error);
                                    }
                                    if (common.IsSuccessful) {
                                        hud.labelText = @"充值成功";
                                        [hud hide:YES afterDelay:1.0];
                                        hud.delegate = self;
                                        
                                    } else {
                                        hud.labelText = common.ResponseMessage;
                                        [hud hide:YES afterDelay:1.5];
                                    }
                                    
                                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                    NSLog(@"failure %@", errorMsg);
                                    hud.labelText = errorMsg;
                                    [hud hide:YES afterDelay:1.5];
                                }];
        
    }
    
}


- (void)payButtonTapped:(UIButton *)button
{
    NSString *cardId = _selectCardView.getSelectedCardId;
    
    if ([_selectCardView isSelectSaveCard]) {
        if (cardId.length) {
            
        } else {
            [self showErrorHud:@"请先添加银行卡"];
            return;
        }
    } else {
        WECardNumberInputView *inputView = _selectCardView.inputNumberView;
        
        if (!inputView.cardNameField.text.length) {
            [self showErrorHud:@"请填写银行卡名称"];
            return;
        }
        if (!inputView.cardNumberField.text.length) {
            [self showErrorHud:@"请填写银行卡号码"];
            return;
        }
        if (!inputView.monthField.text.length) {
            [self showErrorHud:@"请填写有效期月份"];
            return;
        }
        if (!inputView.yearField.text.length) {
            [self showErrorHud:@"请填写有效期年份"];
            return;
        }
        if (!inputView.cvnField.text.length) {
            [self showErrorHud:@"请填写cvn码"];
            return;
        }
        
    }
    [_selectCardView setEditFinished:YES];
    _payButton.hidden = YES;
    _returnButton.hidden = NO;
    _confirmPayButton.hidden = NO;
}


- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
