//
//  WEOrderPayBalanceViewController.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderPayBalanceViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "WEOrderDishListView.h"
#import "WETwoColumnListView.h"
#import "MBProgressHUD.h"
#import "WEModelOrder.h"
#import "WEOrderPayViewController.h"
#import "WEModelCommon.h"
#import "WEShoppingCartManager.h"
#import "UmengStat.h"

@interface WEOrderPayBalanceViewController ()
{
    UIScrollView *_scrollView;
    
    WEOrderDishListView *_dishListView;
    MASConstraint *_dishListViewHeightConstraint;
    
}
@end


@implementation WEOrderPayBalanceViewController
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
    [orderList setUpLeftText:@[@"订单金额", @"优惠券", @"应付金额"]
                   rightText:@[totalValue, couponValue, payValue]];
    [superView addSubview:orderList];
    [orderList makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(20);
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo(orderList.maxWidth);
        make.height.equalTo(orderList.getHeight);
    }];
    
    WETwoColumnListView *balance = [WETwoColumnListView new];
    balance.font = [UIFont systemFontOfSize:18];
    balance.color = [UIColor blackColor];
    balance.middleSpace = 0;
    balance.maxWidth = 170;
    NSString *balanceValue = [NSString stringWithFormat:@"$%.2f", _currentBalance];
    [balance setUpLeftText:@[@"我的余额"] rightText:@[balanceValue]];
    [superView addSubview:balance];
    [balance makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderList.bottom).offset(12);
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo(balance.maxWidth);
        make.height.equalTo(balance.getHeight);
    }];

    UIButton *balancePay = [UIButton new];
    balancePay.backgroundColor = DARK_ORANGE_COLOR;
    balancePay.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    balancePay.layer.cornerRadius=8.0f;
    balancePay.layer.masksToBounds=YES;
    [balancePay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [balancePay setTitle:@"余额支付" forState:UIControlStateNormal];
    [balancePay addTarget:self action:@selector(payButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:balancePay];
    [balancePay makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(balance.bottom).offset(15);
        make.height.equalTo(25);
        make.width.equalTo(balance.maxWidth);
    }];

    
    WEOrderDishListView *dishListView = [WEOrderDishListView new];
    [superView addSubview:dishListView];
    [dishListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balancePay.bottom).offset(40);
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
    [UmengStat pageEnter:UMENG_STAT_PAGE_PAY_BALANCE];
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
    [UmengStat pageLeave:UMENG_STAT_PAGE_PAY_BALANCE];
}

- (void)payButtonTapped:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在支付，请稍后...";
    [hud show:YES];
    
    [WENetUtil CheckoutUsingBalanceWithOrderId:_order.Id
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           JSONModelError* error = nil;
                                           NSDictionary *dict = (NSDictionary *)responseObject;
                                           WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                           if (error) {
                                               NSLog(@"error %@", error);
                                           }
                                           if (common.IsSuccessful) {
                                               hud.labelText = @"支付成功";
                                               [hud hide:YES afterDelay:1.0];
                                               hud.delegate = self;
                                               [[WEShoppingCartManager sharedInstance] removeKitchenCart:_order.KitchenId isToday:_isToday];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KITCHEN_ORDER_CHANGE object:nil];
                                               
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

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateTableHeight
{
    _dishListViewHeightConstraint.equalTo( _dishListView.tableView.contentSize.height );
}




@end
