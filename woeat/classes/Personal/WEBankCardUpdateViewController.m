//
//  WEBankCardUpdateViewController.m
//  woeat
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEBankCardUpdateViewController.h"
#import "WENetUtil.h"
#import "MBProgressHUD.h"
#import "WEModelCommon.h"
#import "WEModelGetMyCardList.h"
#import "WELeftTextField.h"
#import "WEUtil.h"
#import "UmengStat.h"

@interface WEBankCardUpdateViewController ()
{
    UITextField *_cardNameField;
    WELeftTextField *_monthField;
    WELeftTextField *_yearField;
    
}
@end

@implementation WEBankCardUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"修改银行卡";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    float vSpace = 15;
    float leftX = 20;
    float textFieldHeight = 30;
    UIColor *boarderColor = UICOLOR(0xD7, 0xD7, 0xD7);
    
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
        make.top.equalTo(self.mas_topLayoutGuide).offset(vSpace);
    }];
    
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
    _cardNameField.text = _model.Name;
    
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
        make.top.equalTo(_cardNameField.bottom).offset(3);
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
    _monthField.text = [NSString stringWithFormat:@"%d", _model.ExpirationMonth];
    
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
    _yearField.text = [NSString stringWithFormat:@"%d", _model.ExpirationYear];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addRightNavButton:@"保存" image:nil target:self selector:@selector(rightButtonTapped:)];
    [UmengStat pageEnter:UMENG_STAT_PAGE_BANK_CARD_UPDATE];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_BANK_CARD_UPDATE];
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
    if (!_cardNameField.text.length) {
        [self showErrorHud:@"请填写银行卡名称"];
        return;
    }
    if (!_monthField.text.length) {
        [self showErrorHud:@"请填写有效期月份"];
        return;
    }
    if (!_yearField.text.length) {
        [self showErrorHud:@"请填写有效期年份"];
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
    
    [WENetUtil UpdateCardWithBankCardId:_model.Id
                                   Name:_cardNameField.text
                            ExpiryMonth:_monthField.text
                             ExpiryYear:_yearField.text
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    JSONModelError* error = nil;
                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                    WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                    if (error) {
                                        NSLog(@"error %@", error);
                                    }
                                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                    if ([common.ResponseCode isEqualToString:@"200"]) {
                                        hud.labelText = @"修改成功";
                                        [hud hide:YES afterDelay:1.0];
                                        hud.delegate = self;
                                        
                                    } else {
                                        hud.labelText = common.ResponseMessage;
                                        [hud hide:YES afterDelay:1.5];
                                    }
                                }
                                failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                    hud.labelText = errorMsg;
                                    [hud hide:YES afterDelay:1.5];
                                }];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
