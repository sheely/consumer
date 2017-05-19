//
//  WEOrderPayViewController.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderPayViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "WEOrderPayButton.h"
#import "WEOrderDishCell.h"
#import "UIImageView+WebCache.h"
#import "WEOrderDishListView.h"
#import "WEOrderPayCreditCardViewController.h"
#import "WEOrderPayBalanceViewController.h"
#import "WEModelOrder.h"
#import "MBProgressHUD.h"
#import "WEModelOrder.h"
#import "WEOrderPayViewController.h"
#import "WEModelCommon.h"
#import "WERechargeViewController.h"
#import "UmengStat.h"

#define TAG_PAY_BUTTON_START 100

@interface WEOrderPayViewController ()
{
    UIScrollView *_scrollView;
    
    WEOrderDishListView *_dishListView;
    MASConstraint *_dishListViewHeightConstraint;
    
    WEOrderPayButton *_balanceFull;
    WEOrderPayButton *_balanceEmpty;
    float _currentBalance;
}
@end

@implementation WEOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"支付订单";
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
    
    float payButtonHeight = 110;
    float spaceY = 10;
    float offsetX = 15;
    WEOrderPayButton *payButton1 = [WEOrderPayButton new];
    payButton1.tag = TAG_PAY_BUTTON_START;
    payButton1.backgroundColor = DARK_ORANGE_COLOR;
    payButton1.upTitle = @"余额支付";
    payButton1.bottomTitle1 = @"我的余额";
    //payButton1.bottomTitle2 = @"$200.00";
    payButton1.bottomTitle1Color = [UIColor blackColor];
    payButton1.arrowIsGray = YES;
    [payButton1 setHeight:payButtonHeight];
    [payButton1 addTarget:self action:@selector(payButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:payButton1];
    [payButton1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(spaceY);
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(payButtonHeight);
    }];
    _balanceFull = payButton1;
    
    WEOrderPayButton *payButton2 = [WEOrderPayButton new];
    payButton2.tag = TAG_PAY_BUTTON_START + 1;
    payButton2.backgroundColor = UICOLOR(199, 199, 203);
    payButton2.upTitle = @"余额支付";
    payButton2.bottomTitle1 = @"余额不足";
    //payButton2.bottomTitle2 = @"$10.00";
    payButton2.bottomTitle1Color = DARK_ORANGE_COLOR;
    payButton2.arrowIsGray = NO;
    payButton2.rightTitle = @"去充值";
    [payButton2 setHeight:payButtonHeight];
    [payButton2 addTarget:self action:@selector(payButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:payButton2];
    [payButton2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payButton1.top);
        make.left.equalTo(payButton1.left);
        make.right.equalTo(payButton1.right);
        make.height.equalTo(payButton1.height);
    }];
    _balanceEmpty = payButton2;
    _balanceEmpty.hidden = YES;

    WEOrderPayButton *payButton3 = [WEOrderPayButton new];
    payButton3.tag = TAG_PAY_BUTTON_START + 2;
    payButton3.backgroundColor = DARK_ORANGE_COLOR;
    payButton3.upTitle = @"信用卡支付";
    payButton3.arrowIsGray = YES;
    [payButton3 setHeight:payButtonHeight];
    [payButton3 addTarget:self action:@selector(payButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:payButton3];
    [payButton3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payButton2.bottom).offset(spaceY);
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(payButtonHeight);
    }];

    WEOrderDishListView *dishListView = [WEOrderDishListView new];
    [superView addSubview:dishListView];
    [dishListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payButton3.bottom).offset(20);
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
    [self loadBalance];
    [UmengStat pageEnter:UMENG_STAT_PAGE_PAY_LIST];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTableHeight];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_PAY_LIST];
}

- (void)loadBalance
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取余额，请稍后...";
    [hud show:YES];
    [WENetUtil GetMyBalanceWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *ResponseCode = [dict objectForKey:@"ResponseCode"];
        if ([ResponseCode isEqualToString:@"200"]) {
            [hud hide:YES afterDelay:0];
            _currentBalance = [[dict objectForKey:@"Balance"] floatValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_currentBalance >= _order.PayableValue) {
                    _balanceEmpty.hidden = YES;
                    _balanceFull.hidden = NO;
                    _balanceFull.bottomTitle2 = [NSString stringWithFormat:@"$%.2f", _currentBalance];
                    
                } else {
                    _balanceEmpty.hidden = NO;
                    _balanceFull.hidden = YES;
                    _balanceEmpty.bottomTitle2 = [NSString stringWithFormat:@"$%.2f", _currentBalance];
                }
                
            });
        } else {
            NSString *ResponseMessage = [dict objectForKey:@"ResponseMessage"];
            hud.labelText = ResponseMessage;
            [hud hide:YES afterDelay:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"failure %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}

- (void)rightButtonTapped:(UIButton *)button
{
   
}



- (void)updateTableHeight
{
    _dishListViewHeightConstraint.equalTo( _dishListView.tableView.contentSize.height );
}



- (void)payButtonTapped:(UIButton *)button
{
    if (button.tag == TAG_PAY_BUTTON_START) {
        WEOrderPayBalanceViewController *c = [WEOrderPayBalanceViewController new];
        c.kitchenInfo = _kitchenInfo;
        c.order = _order;
        c.isToday = _isToday;
        c.currentBalance = _currentBalance;
        [self.navigationController pushViewController:c animated:YES];
        
        
    } else if (button.tag == TAG_PAY_BUTTON_START + 1) {
        WERechargeViewController *c = [WERechargeViewController new];
        c.kitchenInfo = _kitchenInfo;
        c.order = _order;
        c.isToday = _isToday;
        c.currentBalance = _currentBalance;
        [self.navigationController pushViewController:c animated:YES];
        
    } else {
        WEOrderPayCreditCardViewController *c = [WEOrderPayCreditCardViewController new];
        c.kitchenInfo = _kitchenInfo;
        c.order = _order;
        c.isToday = _isToday;
        [self.navigationController pushViewController:c animated:YES];
    }
}
@end
