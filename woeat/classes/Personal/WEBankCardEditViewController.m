//
//  WEBankCardEditViewController.m
//  woeat
//
//  Created by liubin on 17/3/16.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEBankCardEditViewController.h"
#import "WENetUtil.h"
#import "WECardNumberInputView.h"
#import "MBProgressHUD.h"
#import "WEModelCommon.h"
#import "UmengStat.h"

@interface WEBankCardEditViewController ()
{
    WECardNumberInputView *_inputView;
}
@end

@implementation WEBankCardEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    WECardNumberInputView *inputView = [WECardNumberInputView new];
    inputView.parentController = self;
    [superView addSubview:inputView];
    [inputView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left).offset(25);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo([inputView getHeight]);
    }];
    _inputView = inputView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addRightNavButton:@"保存" image:nil target:self selector:@selector(rightButtonTapped:)];
    [UmengStat pageEnter:UMENG_STAT_PAGE_BANK_CARD_ADD];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_BANK_CARD_ADD];
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

- (void)rightButtonTapped:(UIButton *)button
{
    if (!_inputView.cardNameField.text.length) {
        [self showErrorHud:@"请填写银行卡名称"];
        return;
    }
    if (!_inputView.cardNumberField.text.length) {
        [self showErrorHud:@"请填写银行卡号码"];
        return;
    }
    if (!_inputView.monthField.text.length) {
        [self showErrorHud:@"请填写有效期月份"];
        return;
    }
    if (!_inputView.yearField.text.length) {
        [self showErrorHud:@"请填写有效期年份"];
        return;
    }
    if (!_inputView.cvnField.text.length) {
        [self showErrorHud:@"请填写cvn码"];
        return;
    }
   
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存银行卡，请稍后...";
    [hud show:YES];
   
    [WENetUtil AddCardWithName:_inputView.cardNameField.text
                    CardNumber:_inputView.cardNumberField.text
                   ExpiryMonth:_inputView.monthField.text
                    ExpiryYear:_inputView.yearField.text
                           Cvn:_inputView.cvnField.text
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           JSONModelError* error = nil;
                           NSDictionary *dict = (NSDictionary *)responseObject;
                           WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                           if (error) {
                               NSLog(@"error %@", error);
                           }
                           MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                           if ([common.ResponseCode isEqualToString:@"200"]) {
                               hud.labelText = @"保存成功";
                               [hud hide:YES afterDelay:1.0];
                               hud.delegate = self;
                              
                           } else {
                               hud.labelText = common.ResponseMessage;
                               [hud hide:YES afterDelay:1.5];
                           }
                           
                       } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                           MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                           hud.labelText = errorMsg;
                           [hud hide:YES afterDelay:1.5];
                       }];
    
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
