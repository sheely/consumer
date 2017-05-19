//
//  WERegisterViewController.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WERegisterViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "WEUtil.h"
#import "AppDelegate.h"

@interface WERegisterViewController ()

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UITextField *passTextField;
@end

@implementation WERegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新用户注册";
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    UIView *superView = self.view;
    float buttonHeigh = COND_HEIGHT_480(35, 30);
    float logoHeight = COND_HEIGHT_480(100, 80);
    float logoWidth = COND_HEIGHT_480(150, 100);
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [logo setBackgroundColor:UICOLOR(100, 100, 100)];
    [superView addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo(logoWidth);
        make.height.equalTo(logoHeight);
    }];
    
    UITextField *userNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    userNameTextField.backgroundColor = [UIColor clearColor];
    userNameTextField.delegate = self;
    userNameTextField.returnKeyType = UIReturnKeyNext;
    userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameTextField.font = [UIFont systemFontOfSize:15];
    userNameTextField.textColor = [UIColor blackColor];
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    userNameTextField.layer.cornerRadius=8.0f;
    userNameTextField.layer.masksToBounds=YES;
    userNameTextField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    userNameTextField.layer.borderWidth= 1.0f;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    userNameTextField.leftView = view1;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150)}];
    self.phoneTextField = userNameTextField;
    [superView addSubview:userNameTextField];
    [userNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(logo.bottom).offset(15);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    passwordTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.delegate = self;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = YES;
    
    passwordTextField.layer.cornerRadius=8.0f;
    passwordTextField.layer.masksToBounds=YES;
    passwordTextField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    passwordTextField.layer.borderWidth= 1.0f;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    passwordTextField.leftView = view2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.codeTextField = passwordTextField;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150)}];
    [superView addSubview:passwordTextField];
    [passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.centerX);
        make.left.equalTo(superView.left).offset(20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(userNameTextField.bottom).offset(10);
    }];
    
    
    UIButton *sendButton = [UIButton new];
    [sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendButton setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.backgroundColor = DARK_ORANGE_COLOR;
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    sendButton.layer.cornerRadius=8.0f;
    sendButton.layer.masksToBounds=YES;
    [superView addSubview:sendButton];
    [sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTextField.right).offset(10);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(self.codeTextField.top);
    }];
    
    UITextField *passTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    passTextField.backgroundColor = [UIColor clearColor];
    passTextField.delegate = self;
    passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passTextField.font = [UIFont systemFontOfSize:15];
    passTextField.textColor = [UIColor blackColor];
    passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTextField.layer.cornerRadius=8.0f;
    passTextField.layer.masksToBounds=YES;
    passTextField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    passTextField.layer.borderWidth= 1.0f;
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    passTextField.leftView = view3;
    passTextField.leftViewMode = UITextFieldViewModeAlways;
    
    passTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设定密码" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150)}];
    self.passTextField = passTextField;
    [superView addSubview:passTextField];
    [passTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(sendButton.bottom).offset(10);
    }];

    
    UIButton *sendNewButton = [UIButton new];
    [sendNewButton setTitle:@"完成注册" forState:UIControlStateNormal];
    sendNewButton.backgroundColor = DARK_ORANGE_COLOR;
    [sendNewButton setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [sendNewButton addTarget:self action:@selector(finishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendNewButton.titleLabel.font = [UIFont systemFontOfSize:15];
    sendNewButton.layer.cornerRadius=8.0f;
    sendNewButton.layer.masksToBounds=YES;
    [superView addSubview:sendNewButton];
    [sendNewButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.top.equalTo(passTextField.bottom).offset(10);
        make.height.equalTo(buttonHeigh);
    }];
    
    UILabel *title1 = [UILabel new];
    title1.backgroundColor = [UIColor clearColor];
    title1.font = [UIFont systemFontOfSize:15];
    title1.textColor = UICOLOR(145, 145, 145);
    title1.text = @"没收到验证码？46秒后重发";
    [superView addSubview:title1];
    [title1 sizeToFit];
    [title1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(sendNewButton.bottom).offset(20);
    }];
    
}

- (void)sendButtonClicked:(UIButton *)button
{
    
}

- (void)finishButtonClicked:(UIButton *)button
{
    
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
