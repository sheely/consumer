//
//  WELoginViewController.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WELoginViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "WEUtil.h"
#import "AppDelegate.h"
#import "WEForgetPasswordViewController.h"
#import "WERegisterViewController.h"
#import "WENetUtil.h"
#import "WEModeluserLogin.h"
#import "MBProgressHUD.h"
#import "YYKit.h"
#import "WEGlobalData.h"
#import "WEToken.h"
#import "WESingleWebViewController.h"
#import "UmengStat.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface WELoginViewController ()
{
    
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@property(nonatomic, strong) UITextField *userTextField;
@property(nonatomic, strong) UITextField *passTextField;
@end

@implementation WELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 50;
    
    UIView *superView = self.view;
    float buttonHeigh = COND_HEIGHT_480(35, 30);
    
    float logoScale = COND_HEIGHT_480(1.0, 0.5);
    UIImage *logoImg = [UIImage imageNamed:@"icon_log_medium"];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectZero];
    logo.image = logoImg;
    [superView addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.centerX.equalTo(superView.centerX).offset(-15 * logoScale);
        make.width.equalTo(logoImg.size.width * logoScale);
        make.height.equalTo(logoImg.size.height * logoScale);
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
    self.userTextField = userNameTextField;
    [superView addSubview:userNameTextField];
    [userNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(logo.bottom).offset(20);
    }];
    
    UIButton *sendButton = [UIButton new];
    [sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendButton setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.backgroundColor = DARK_ORANGE_COLOR;
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    sendButton.layer.cornerRadius=8.0f;
    sendButton.layer.masksToBounds=YES;
    [superView addSubview:sendButton];
    [sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-20);
        make.centerY.equalTo(userNameTextField.centerY);
        make.height.equalTo(userNameTextField.height).offset(0);
        make.width.equalTo([WEUtil getScreenWidth] * 0.3);
    }];

    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    passwordTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.delegate = self;
    passwordTextField.returnKeyType = UIReturnKeyGo;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = NO;
    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    passwordTextField.layer.cornerRadius=8.0f;
    passwordTextField.layer.masksToBounds=YES;
    passwordTextField.layer.borderColor=DARK_ORANGE_COLOR.CGColor;
    passwordTextField.layer.borderWidth= 1.0f;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    passwordTextField.leftView = view2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passTextField = passwordTextField;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150)}];
    [superView addSubview:passwordTextField];
    [passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(userNameTextField.bottom).offset(10);
    }];

    //login button
    UIButton *loginButton = [UIButton new];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = DARK_ORANGE_COLOR;
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    loginButton.layer.cornerRadius=8.0f;
    loginButton.layer.masksToBounds=YES;
    [superView addSubview:loginButton];
    [loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.left.equalTo(superView.left).offset(20);
        make.right.equalTo(superView.right).offset(-20);
        make.height.equalTo(buttonHeigh);
        make.top.equalTo(passwordTextField.bottom).offset(10);
    }];
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"温馨提示 : 未注册WOEAT账号的手机号，登录时将自动注册，且代表您已同意 用户协议"];
    one.font = [UIFont systemFontOfSize:16];
    one.color = [UIColor grayColor];
    [one setLineSpacing:1 range:one.rangeOfAll];
    NSRange range = [one.string rangeOfString:@"用户协议"];
    
    [one setTextHighlightRange:range
                             color:DARK_ORANGE_COLOR
                   backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             WESingleWebViewController *vc = [WESingleWebViewController new];
                             vc.titleString = @"用户协议";
                             vc.urlString = URL_USER_AGREEMENT;
                             [self.navigationController pushViewController:vc animated:YES];
                         }];
    
    YYLabel *tip = [YYLabel new];
    tip.numberOfLines = 0;
    [superView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton.left).offset(15);
        make.right.equalTo(loginButton.right).offset(-15);
        make.top.equalTo(loginButton.bottom).offset(15);
        make.height.equalTo(80);
    }];
    tip.attributedText = one;

    //forget password
//    UIButton *forgetButton = [UIButton new];
//    [forgetButton setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
//    [forgetButton setTitleColor:DARK_ORANGE_COLOR forState:UIControlStateNormal];
//    [forgetButton addTarget:self action:@selector(forgetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    forgetButton.backgroundColor = [UIColor clearColor];
//    [superView addSubview:forgetButton];
//    [forgetButton sizeToFit];
//    [forgetButton makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(superView.right).offset(-20);
//        make.top.equalTo(loginButton.bottom).offset(10);
//    }];
//    
//    float offset = COND_HEIGHT_480(50, 20);
//    UILabel *title1 = [UILabel new];
//    title1.backgroundColor = [UIColor clearColor];
//    title1.font = [UIFont systemFontOfSize:15];
//    title1.textColor = UICOLOR(175, 175, 175);
//    title1.text = @"点击登录，即表示您同意";
//    [superView addSubview:title1];
//    [title1 sizeToFit];
//    [title1 makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(superView.centerX).offset(-30);
//        make.top.equalTo(forgetButton.bottom).offset(offset);
//    }];
//    
//    UIButton *userAgreement = [UIButton new];
//    [userAgreement setTitle:@"用户协议" forState:UIControlStateNormal];
//    [userAgreement setTitleColor:DARK_ORANGE_COLOR forState:UIControlStateNormal];
//    [userAgreement addTarget:self action:@selector(userAgreementClicked:) forControlEvents:UIControlEventTouchUpInside];
//    userAgreement.titleLabel.font = [UIFont systemFontOfSize:15];
//    userAgreement.backgroundColor = [UIColor clearColor];
//    [superView addSubview:userAgreement];
//    [userAgreement sizeToFit];
//    [userAgreement makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(title1.centerY);
//        make.left.equalTo(title1.right).offset(10);
//    }];
//
//    UILabel *title2 = [UILabel new];
//    title2.backgroundColor = [UIColor clearColor];
//    title2.font = [UIFont systemFontOfSize:17];
//    title2.textColor = UICOLOR(175, 175, 175);
//    title2.text = @"还没有注册？";
//    [superView addSubview:title2];
//    [title2 sizeToFit];
//    [title2 makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(superView.centerX);
//    }];
//    
//    UIButton *registerButton = [UIButton new];
//    [registerButton setTitle:@"立刻免费注册" forState:UIControlStateNormal];
//    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
//    registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    registerButton.backgroundColor = DARK_ORANGE_COLOR;
//    [superView addSubview:registerButton];
//    [registerButton makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(superView.centerX);
//        make.top.equalTo(title2.bottom).offset(15);
//        make.width.equalTo(180);
//        make.height.equalTo(buttonHeigh);
//        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-30);
//    }];
//
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PHONE];
    _userTextField.text = phone;
    [UmengStat pageEnter:UMENG_STAT_PAGE_LOGIN];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_LOGIN];
}


- (void)sendButtonClicked:(UIButton *)button
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.yOffset = -30;
    [self.view addSubview:hud];
    if (!_userTextField.text.length) {
        hud.labelText = @"请先输入手机号码";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        return;
    }
    
    hud.labelText = @"正在发送验证码，请稍后...";
    [hud show:YES];
    
    [WENetUtil sendSecurityCodeWithPhoneNumber:_userTextField.text success:^(NSURLSessionDataTask *task, id responseObject) {
        hud.labelText = @"验证码已发送，请查收";
        [hud hide:YES afterDelay:1.5];
        self.passTextField.text = [responseObject valueForKey:@"SecurityCode"];
        UIButton *sendButton = button;
        __block int timeout=59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                    sendButton.userInteractionEnabled = YES;
                    sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [sendButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    sendButton.titleLabel.font = [UIFont systemFontOfSize:11];
                    sendButton.userInteractionEnabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}


- (void)loginButtonClicked:(UIButton *)button
{
#if TEST_AUTO_LOGIN
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setRootToMainTabController:self];
    
#else
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.yOffset = -30;
    [self.view addSubview:hud];
    if (!_userTextField.text.length) {
        hud.labelText = @"请输入手机号码";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        return;
    }
    if (!_passTextField.text.length) {
        hud.labelText = @"请输入验证码";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
        return;
    }
    
    hud.labelText = @"正在登录，请稍后...";
    [hud show:YES];
    
    [WENetUtil userLoginWithPhoneNumber:_userTextField.text securityCode:_passTextField.text success:^(NSURLSessionDataTask *task, id responseObject) {
        
        hud.labelText = @"登录成功";
        [hud hide:YES afterDelay:1];
        
        
        NSLog(@"class %@",[responseObject class]);

        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModeluserLogin *model = [[WEModeluserLogin alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        [[NSUserDefaults standardUserDefaults] setObject:_userTextField.text forKey:USER_DEFAULT_PHONE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [WEGlobalData sharedInstance].curUserName = _userTextField.text;
        [WEGlobalData logIn];
        
        NSString *s = [NSString stringWithFormat:@"%@ %@", model.token_type, model.access_token];
        [WEToken saveToken:s];
        [UmengStat signIn:_userTextField.text];
        [CrashlyticsKit setUserIdentifier:_userTextField.text];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setRootToMainTabController:self];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];

#endif
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    
}

//- (void)forgetButtonClicked:(UIButton *)button
//{
//    WEForgetPasswordViewController *vc = [WEForgetPasswordViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//
//- (void)userAgreementClicked:(UIButton *)button
//{
//    WEUserAgreementViewController *vc = [WEUserAgreementViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
//
//
//- (void)registerClicked:(UIButton *)button
//{
//    WERegisterViewController *vc = [WERegisterViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//

- (void)dealloc
{
    self.returnKeyHandler = nil;
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
