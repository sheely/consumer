//
//  WECouponListViewController.m
//  woeat
//
//  Created by liubin on 16/11/30.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WECouponListViewController.h"
#import "WECouponListCell.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "MBProgressHUD.h"
#import "WEModelClaimCoupon.h"
#import "WEModelGetMyRedeemableCoupon.h"
#import "WEGlobalData.h"
#import "WEModelOrder.h"
#import "WEModelCommon.h"
#import "UmengStat.h"

@interface WECouponListViewController ()
{
    UITableView *_tableView;
    UITextField *_codeField;
    WEModelGetMyRedeemableCoupon *_modelGetMyRedeemableCoupon;
}
@end

@implementation WECouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的优惠券";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.backgroundColor = UICOLOR(221, 221, 221);
    field.delegate = self;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.font = [UIFont systemFontOfSize:13];
    field.textColor = [UIColor blackColor];
    field.keyboardType = UIKeyboardTypeNamePhonePad;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.layer.cornerRadius = 5;
    field.layer.masksToBounds=YES;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    field.leftView = view1;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入优惠码" attributes:@{NSForegroundColorAttributeName: UICOLOR(180, 180, 180)}];
    [superView addSubview:field];
    [field makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo([WEUtil getScreenWidth]*0.5);
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.height.equalTo(25);
    }];
    _codeField = field;

    UIButton *button = [UIButton new];
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:DARK_ORANGE_COLOR forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exchangeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(field.centerY);
        make.left.equalTo(field.right).offset(0);
        make.width.equalTo(40);
        make.height.equalTo(20);
    }];
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WECouponListCell class] forCellReuseIdentifier:@"WECouponListCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(field.bottom).offset(10);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAllCoupon:nil];
    [UmengStat pageEnter:UMENG_STAT_PAGE_COUPON];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_COUPON];
}


- (void)loadAllCoupon:(NSString *)hudText
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    if (!hudText) {
        hud.labelText = @"正在获取优惠券信息，请稍后...";
    } else {
        hud.labelText = hudText;
    }
    [hud show:YES];
    
    [WENetUtil GetMyRedeemableCouponWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [hud hide:YES afterDelay:0];
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyRedeemableCoupon *model = [[WEModelGetMyRedeemableCoupon alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _modelGetMyRedeemableCoupon = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelGetMyRedeemableCoupon.UserCouponList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WECouponListCell";
    WECouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WECouponListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    WEModelGetMyRedeemableCouponUserCouponList *model = [_modelGetMyRedeemableCoupon.UserCouponList objectAtIndex:indexPath.row];
    [cell setModel:model];
    if (_fromOrderId) {
        if ([[WEGlobalData sharedInstance].selectedCouponId isEqualToString:model.UserCouponId]) {
            [cell setIsSelected:YES];
        } else {
            [cell setIsSelected:NO];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fromOrderId) {
        WEModelGetMyRedeemableCouponUserCouponList *model = [_modelGetMyRedeemableCoupon.UserCouponList objectAtIndex:indexPath.row];
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            //hud.yOffset = -30;
            [self.view addSubview:hud];
        }
        hud.labelText = @"正在验证优惠码，请稍后...";
        [hud show:YES];
        
        [WENetUtil AddCouponToOrderWithCouponId:model.UserCouponId OrderId:_fromOrderId
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            NSDictionary *dict = (NSDictionary *)responseObject;
                                            JSONModelError* error = nil;
                                            WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                            if (error) {
                                                NSLog(@"error %@", error);
                                            }
                                            if (!res.IsSuccessful) {
                                                hud.labelText = res.ResponseMessage;
                                                [hud hide:YES afterDelay:1.5];
                                                return;
                                            }
                                            hud.labelText = @"添加成功";
                                            [hud hide:YES afterDelay:1.0];
                                            [WEGlobalData sharedInstance].selectedCouponId = model.UserCouponId;
                                            [WEGlobalData sharedInstance].selectedCouponDesc = [NSString stringWithFormat:@"%@ %@",
                                                                                                model.RuleValueDescription, model.RuleDescription];
                                            [_tableView reloadData];
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                            NSLog(@"errorMsg %@", errorMsg);
                                            hud.labelText = errorMsg;
                                            [hud hide:YES afterDelay:1.5];
                                        }];
        
    }
}


- (void)exchangeButtonTapped:(UIButton *)button
{
    if (_codeField.text.length == 0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在兑换优惠码，请稍后...";
    [hud show:YES];
    
    [WENetUtil ClaimCouponWithCouponCode:_codeField.text success:^(NSURLSessionDataTask *task, id responseObject) {
        [_codeField resignFirstResponder];
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelClaimCoupon *model = [[WEModelClaimCoupon alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (!model.IsSuccessful) {
            hud.labelText = model.ResponseMessage;
            [hud hide:YES afterDelay:1.5];
            return;
        }
        [self performSelectorOnMainThread:@selector(loadAllCoupon:) withObject:@"兑换成功" waitUntilDone:NO];
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        [_codeField resignFirstResponder];
        NSLog(@"errorMsg %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}

@end
