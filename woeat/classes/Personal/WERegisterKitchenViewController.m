//
//  WERegisterKitchenViewController.m
//  woeat
//
//  Created by liubin on 17/1/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WERegisterKitchenViewController.h"
#import "WEUtil.h"
#import "MBProgressHUD.h"
#import "WEAddress.h"
#import "WEAddressManager.h"
#import "WESearchCityViewController.h"
#import "WEState.h"
#import "WECity.h"
#import "WERightImageLeftLabelButton.h"
#import "WENetUtil.h"
#import "WEUserDataManager.h"
#import "WESingleWebViewController.h"
#import "WEModelCommon.h"
#import "UmengStat.h"

@interface WERegisterKitchenViewController ()
{
    UITextField *_personNameField;
    UITextField *_kitchenNameField;
    UITextField *_streetField;
    UITextField *_codeField;
    WERightImageLeftLabelButton *_stateButton;
    WERightImageLeftLabelButton *_cityButton;
    
    NSString *_personName;
    NSString *_kitchenName;
    NSString *_street;
    NSString *_code;
    int _stateId;
    NSString *_stateName;
    NSString *_cityName;
}
@end

@implementation WERegisterKitchenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"成为家厨";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    
    UILabel *tip = [UILabel new];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor blackColor];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = [UIFont boldSystemFontOfSize:13];
    [superView addSubview:tip];
    [tip sizeToFit];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(self.mas_topLayoutGuide).offset(15);
    }];
    tip.text = @"只需填写简单信息，即可申请成为家厨";
    
    float fieldHeight = 25;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    textField.layer.borderWidth= 1.0f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view1;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"厨师的名字" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(tip.bottom).offset(10);
    }];
    _personNameField = textField;
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    textField.layer.borderWidth= 1.0f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view2;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"厨房的名字" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
         NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_personNameField.bottom).offset(10);
    }];
    _kitchenNameField = textField;
    
    tip = [UILabel new];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor blackColor];
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = [UIFont boldSystemFontOfSize:13];
    [superView addSubview:tip];
    [tip sizeToFit];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(_kitchenNameField.bottom).offset(15);
    }];
    tip.text = @"厨房地址";
    
    UIImage *grayArrow = [UIImage imageNamed:@"icon_arrow_gray"];
    WERightImageLeftLabelButton *stateButton = [[WERightImageLeftLabelButton alloc] initWithImage:grayArrow title:@"州"];
    stateButton.label.textColor = [UIColor blackColor];
    [stateButton addTarget:self action:@selector(stateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:stateButton];
    [stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip.left);
        make.top.equalTo(tip.bottom).offset(5);
        make.width.equalTo([WEUtil getScreenWidth]*0.45);
        make.height.equalTo(25);
    }];
    _stateButton = stateButton;
    
    WERightImageLeftLabelButton *cityButton = [[WERightImageLeftLabelButton alloc] initWithImage:grayArrow title:@"城市"];
    cityButton.label.textColor = [UIColor blackColor];
    [cityButton addTarget:self action:@selector(cityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:cityButton];
    [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset([WEUtil getScreenWidth]*0.5 + 15);
        make.centerY.equalTo(stateButton.centerY);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(stateButton.height);
    }];
    _cityButton = cityButton;
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.layer.borderWidth= 1.0f;
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view3;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"详细地址" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_stateButton.bottom).offset(5);
    }];
    _streetField = textField;
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    textField.layer.borderWidth= 1.0f;
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view4;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮政编码" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight);
        make.top.equalTo(_streetField.bottom).offset(10);
    }];
    _codeField = textField;
    
    UIButton *button = [UIButton new];
    [button setTitle:@"完成注册" forState:UIControlStateNormal];
    [button setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerFinishedTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = DARK_ORANGE_COLOR;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    button.layer.cornerRadius=8.0f;
    button.layer.masksToBounds=YES;
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(fieldHeight+5);
        make.top.equalTo(_codeField.bottom).offset(10);
    }];

    [self initData];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UmengStat pageEnter:UMENG_STAT_PAGE_APPLY_KITCHENER];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_APPLY_KITCHENER];
}


- (void)initData
{
    _street = _address.house;
    _code = _address.postCode;
    _stateId = _address.stateId.integerValue;
    _stateName = _address.stateName;
    _cityName = _address.cityName;
}

- (void)updateUI
{
    _personNameField.text = _personName;
    _kitchenNameField.text = _kitchenName;
    _streetField.text = _street;
    _codeField.text = _code;
    if (_stateName.length) {
        _stateButton.label.text = [NSString stringWithFormat:@"州 %@", _stateName];
        _stateButton.label.textColor = [UIColor blackColor];
    } else {
        _stateButton.label.text = @"州";
        _stateButton.label.textColor = [UIColor lightGrayColor];
    }
    if (_cityName.length) {
        _cityButton.label.text = [NSString stringWithFormat:@"城市 %@", _cityName];
        _cityButton.label.textColor = [UIColor blackColor];
    } else {
        _cityButton.label.text = @"城市";
        _cityButton.label.textColor = [UIColor lightGrayColor];
    }
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

- (void)registerFinishedTapped:(UIButton *)button
{
    if (!_personName.length) {
        [self showErrorHud:@"请填写厨师姓名"];
        return;
    }
    if (!_kitchenName.length) {
        [self showErrorHud:@"请填写厨房姓名"];
        return;
    }
    if (!_street.length) {
        [self showErrorHud:@"请填写厨房详细地址"];
        return;
    }
    if (!_code.length) {
        [self showErrorHud:@"请填写邮政编码"];
        return;
    }
    if (!_stateName.length) {
        [self showErrorHud:@"请选择州"];
        return;
    }
    if (!_cityName.length) {
        [self showErrorHud:@"请选择城市"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在发送请求，请稍后...";
    [hud show:YES];
    BOOL isMale = [[WEUserDataManager sharedInstance] isMale];
    [WENetUtil RegisterWithName:_kitchenName
                   ChefUsername:_personName
                         isMale:isMale
                   AddressLine1:_street
                           City:_cityName
                          State:_stateName
                       Postcode:_code
                      Longitude:TEST_Longitude
                       Latitude:TEST_Latitude
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            JSONModelError* error = nil;
                            NSDictionary *dict = (NSDictionary *)responseObject;
                            WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                            if (error) {
                                NSLog(@"error %@", error);
                            }
                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                            if ([common.ResponseCode isEqualToString:@"200"]) {
                                [hud hide:YES afterDelay:0];
                                WESingleWebViewController *c = [WESingleWebViewController new];
                                c.titleString = @"申请成功";
                                c.urlString = URL_REGISTER_KITCHEN_COMPLETE;
                                UINavigationController *nav = self.navigationController;
                                [nav popToRootViewControllerAnimated:NO];
                                [nav pushViewController:c animated:YES];
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


- (void)stateButtonTapped:(UIButton *)button
{
    WESearchCityViewController *c = [WESearchCityViewController new];
    c.stateId = 0;
    c.searchDelegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)cityButtonTapped:(UIButton *)button
{
    if (!_stateId) {
        [self showErrorHud:@"请先选择州"];
        return;
    }
    WESearchCityViewController *c = [WESearchCityViewController new];
    c.stateId = _stateId;
    c.searchDelegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _personNameField) {
        _personName = textField.text;
    } else if (textField == _kitchenNameField) {
        _kitchenName = textField.text;
    }  else if (textField == _streetField) {
        _street = textField.text;
    }  else if (textField == _codeField) {
        _code = textField.text;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _personNameField) {
        _personName = newText;
    } else if (textField == _kitchenNameField) {
        _kitchenName = newText;
    }  else if (textField == _streetField) {
        _street = newText;
    }  else if (textField == _codeField) {
        _code = newText;
    }
    
    return YES;
    
}

- (void)userSelecteState:(WEState *)state
{
    _stateName = state.Name;
    _stateId = state.stateId;
    _cityName = nil;
    [self updateUI];
    
}
- (void)userSelecteCity:(WECity *)city
{
    _cityName = city.Name;
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
