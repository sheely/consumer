//
//  WEOrderConfirmViewController.m
//  woeat
//
//  Created by liubin on 16/12/18.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderConfirmViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "TNRadioButtonGroup.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "WEModelGetConsumerKitchen.h"
#import "WETimePicker.h"
#import "WEPersonalAddressListViewController.h"
#import "WEAddressManager.h"
#import "WEAddress.h"
#import "WEPersonalAddressListViewController.h"
#import "WEPersonalAddressEditViewController.h"
#import "WECouponListViewController.h"
#import "WEGlobalData.h"
#import "WECouponListViewController.h"
#import "MBProgressHUD.h"
#import "WENetUtil.h"
#import "WEModelOrder.h"
#import "WEOrderPayViewController.h"
#import "WEModelCommon.h"
#import "WEKitchenCache.h"

#define DISPATCH_PICKUP    @"PICKUP"
#define DISPATCH_DELIVER   @"DELIVER"

@interface WEOrderConfirmViewController ()
{
    UITableView *_tableView;
    TNRadioButtonGroup *_checkGroup;
    WETimePicker *_timePickview;
    
    NSString *_beginTime;
    //NSString *_endTime;
    
    UITextView *_messageTextView;
    NSString *_messageContent;
    float _messageTextHeight;
    BOOL _placeHolder;
    NSString *_currentDispatchMethod;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation WEOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"填写订单信息";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = YES;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _tableView = tableView;
    
    [WEGlobalData sharedInstance].selectedCouponId = nil;
    [WEGlobalData sharedInstance].selectedCouponDesc = nil;
    
    if (_kitchenInfo && _kitchenInfo.Name) {
        WEKitchenCache *cache = [WEKitchenCache sharedInstance];
        [cache setName:_kitchenInfo.Name forKitchenId:_kitchenInfo.Id];
        [cache setImageUrl:_kitchenInfo.PortraitImageUrl forKitchenId:_kitchenInfo.Id];
        [cache setCanPickup:_kitchenInfo.CanPickup forKitchenId:_kitchenInfo.Id];
        [cache setCanDiliver:_kitchenInfo.CanDeliver forKitchenId:_kitchenInfo.Id];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [self addRightNavButton:@"完成" image:nil target:self selector:@selector(rightButtonTapped:)];
    [[WEAddressManager sharedInstance] loadAllWithDelegate:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(210, 210, 210);
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 40);
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(20, 0, 200, 40);
    [bg addSubview:label];
    if (section == 0) {
        label.text = @"就餐方式";
    } else if (section == 1) {
        NSString *s;
        if (_isToday) {
            s = @"就餐时间 今天";
        } else {
            s = @"就餐时间 明天";
        }
        label.text = s;
    } else if (section == 2) {
        label.text = @"给店家的留言";
    } else if (section == 3) {
        label.text = @"送餐目的地的地址";
    } else if (section == 4) {
        label.text = @"优惠券";
    }
    return bg;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    
    if (indexPath.section == 0) {
        if (_kitchenInfo.CanPickup && _kitchenInfo.CanDeliver) {
            if (!_checkGroup) {
                TNImageRadioButtonData *data1 = [TNImageRadioButtonData new];
                data1.labelFont = [UIFont systemFontOfSize:13];
                data1.labelActiveColor = [UIColor lightGrayColor];
                data1.labelPassiveColor = [UIColor lightGrayColor];
                data1.labelText = @"外送";
                data1.identifier = DISPATCH_DELIVER;
                data1.selected = YES;
                data1.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
                data1.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
                data1.labelOffset = 5;
                
                TNImageRadioButtonData *data2 = [TNImageRadioButtonData new];
                data2.labelFont = [UIFont systemFontOfSize:13];
                data2.labelActiveColor = [UIColor lightGrayColor];
                data2.labelPassiveColor = [UIColor lightGrayColor];
                data2.labelText = @"自取";
                data2.identifier = DISPATCH_PICKUP;
                data2.selected = NO;
                data2.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
                data2.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
                data2.labelOffset = 5;
                
                TNRadioButtonGroup *group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[data1, data2] layout:TNRadioButtonGroupLayoutHorizontal];
                group.marginBetweenItems = 30;
                group.identifier = @"group";
                [group create];
                group.position = CGPointMake(20, 15);
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dispatchCheckGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:group];
                [group update];
                _checkGroup = group;
            }
            [superView addSubview:_checkGroup];
            _currentDispatchMethod = DISPATCH_DELIVER;
            
        } else if (_kitchenInfo.CanPickup) {
            UILabel *label = [UILabel new];
            label.textColor = UICOLOR(68,68,68);
            label.font = [UIFont systemFontOfSize:13];
            [superView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superView.top).offset(5);
                make.left.equalTo(superView.left).offset(20);
                make.right.equalTo(superView.right);
                make.bottom.equalTo(superView.bottom).offset(-5);
            }];
            label.text = @"自取";
            _currentDispatchMethod = DISPATCH_PICKUP;
            
        } else if (_kitchenInfo.CanDeliver) {
            UILabel *label = [UILabel new];
            label.textColor = UICOLOR(68,68,68);
            label.font = [UIFont systemFontOfSize:13];
            [superView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superView.top).offset(5);
                make.left.equalTo(superView.left).offset(20);
                make.right.equalTo(superView.right);
                make.bottom.equalTo(superView.bottom).offset(-5);
            }];
            label.text = @"外送";
            _currentDispatchMethod = DISPATCH_DELIVER;
        }
        
    } else if (indexPath.section == 1) {
        UIButton *start = [UIButton new];
        start.backgroundColor = DARK_ORANGE_COLOR;
        start.layer.cornerRadius = 4;
        start.layer.masksToBounds = YES;
        [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        start.titleLabel.font = [UIFont systemFontOfSize:13];
        [start addTarget:self action:@selector(showTimePicker:) forControlEvents:UIControlEventTouchUpInside];
        if (_beginTime) {
            NSString *s = [NSString stringWithFormat:@"%@", _beginTime];
            [start setTitle:s forState:UIControlStateNormal];
        } else {
            NSString *s = @"选择时间";
            [start setTitle:s forState:UIControlStateNormal];
        }
        [superView addSubview:start];
        [start mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(20);
            make.width.equalTo(120);
            make.top.equalTo(superView.top).offset(10);
            make.bottom.equalTo(superView.bottom).offset(-10);
        }];
    
    } else if (indexPath.section == 2) {
        UITextView *textView = [UITextView new];
        textView.textColor = UICOLOR(68,68,68);
        textView.scrollEnabled = NO;
        textView.delegate = self;
        [superView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(5);
            make.left.equalTo(superView.left).offset(20);
            make.right.equalTo(superView.right);
            make.bottom.equalTo(superView.bottom).offset(-5);
        }];
        
        if (!_messageContent.length) {
            textView.text = @"未填写";
        }
        _messageTextView = textView;
 
        if (_messageContent.length) {
            _messageTextView.text = _messageContent;
        }
    
    } else if (indexPath.section == 3) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UICOLOR(68, 68, 68);
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(5);
            make.left.equalTo(superView.left).offset(20);
            make.right.equalTo(superView.right).offset(-50);
            make.bottom.equalTo(superView.bottom).offset(-5);
        }];
        NSArray *array = [[WEAddressManager sharedInstance] allAddress];
        if (array.count) {
            int index = [[WEAddressManager sharedInstance] getSelectedIndex];
            if (index < array.count) {
                WEAddress *a = [array objectAtIndex:index];
                label.text = [a getAddressString];
            }
        } else {
            label.text = @"未填写地址";
        }
        
        UIImage *grayArrow = [UIImage imageNamed:@"icon_arrow_gray"];
        UIImageView *arrow = [UIImageView new];
        arrow.image = grayArrow;
        [superView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.right.equalTo(superView.right).offset(-20);
            make.width.equalTo(grayArrow.size.width);
            make.height.equalTo(grayArrow.size.height);
        }];
    
    }  else if (indexPath.section == 4) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UICOLOR(68, 68, 68);
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(5);
            make.left.equalTo(superView.left).offset(20);
            make.right.equalTo(superView.right).offset(-50);
            make.bottom.equalTo(superView.bottom).offset(-5);
        }];
        if ([WEGlobalData sharedInstance].selectedCouponDesc) {
            label.text = [WEGlobalData sharedInstance].selectedCouponDesc;
        } else {
            label.text = @"未选择优惠券";
        }
        
        UIImage *grayArrow = [UIImage imageNamed:@"icon_arrow_gray"];
        UIImageView *arrow = [UIImageView new];
        arrow.image = grayArrow;
        [superView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.right.equalTo(superView.right).offset(-20);
            make.width.equalTo(grayArrow.size.width);
            make.height.equalTo(grayArrow.size.height);
        }];
    }

    
    
    return cell;
    
}
- (void)loadStart
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取地址，请稍后...";
    [hud show:YES];
    
}

- (void)loadFinished
{
    [_tableView reloadData];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (hud) {
        [hud hide:YES afterDelay:0.5];
    }
}

- (void)deleteFinished
{
}

- (void)addFinished
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        NSArray *array = [[WEAddressManager sharedInstance] allAddress];
        if (array.count) {
            WEPersonalAddressListViewController *c = [WEPersonalAddressListViewController new];
            c.fromOrderConfirm = YES;
            [self.navigationController pushViewController:c animated:YES];
        } else {
            WEPersonalAddressEditViewController *c = [WEPersonalAddressEditViewController new];
            c.parentController = self;
//            WEAddress *a = [WEAddress new];
//            WEAddressManager *manager = [WEAddressManager sharedInstance];
//            NSMutableArray *array = [manager loadAddress];
//            c.address = a;
//            [array addObject:a];
            [self.navigationController pushViewController:c animated:YES];
        }
    } else if (indexPath.section == 4) {
        WECouponListViewController *c = [WECouponListViewController new];
        c.fromOrderId = _orderId;
        [self.navigationController pushViewController:c animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else if (indexPath.section == 1) {
        return 45;
    } else if (indexPath.section == 2) {
        if (_messageTextHeight) {
            return _messageTextHeight + 5 + 5;
        } else {
            return 44;
        }
        
    } else {
        return 40;
    }
    
}


- (void)dispatchCheckGroupUpdated:(NSNotification *)notification {
    NSLog(@"group updated to %@", _checkGroup.selectedRadioButton.data.identifier);
    _currentDispatchMethod = _checkGroup.selectedRadioButton.data.identifier;
}

- (void)showTimePicker:(UIButton *)button
{
    if (_timePickview) {
        [_timePickview removeFromSuperview];
        _timePickview = nil;
    }
    if (!_beginTime) {
        NSDate *begin = [NSDate dateWithTimeIntervalSinceNow:60*60];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        _beginTime = [formatter stringFromDate:begin];
    }
    
    _timePickview=[[WETimePicker alloc] initWithDefaultString1:_beginTime];
    _timePickview.delegate = self;
    [self.view addSubview:_timePickview];
    [_timePickview show];
}

- (void)pickerView:(WETimePicker *)pickView reslutString1:(NSString *)resultString1
{
    if (!resultString1) {
        return;
    }
    _beginTime = resultString1;
    [_tableView reloadData];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!_placeHolder && [textView.text isEqualToString:@"未填写"]) {
        _placeHolder = YES;
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _messageContent = textView.text;
    float width = [WEUtil getScreenWidth] - 20;
    //_commentTextHeight = [WEUtil sizeForTitle:textView.text font:textView.font maxWidth:width].height;
    _messageTextHeight = [textView sizeThatFits:CGSizeMake(width, 1000*10)].height;
    //NSLog(@"%f %f", _commentTextHeight, h);
    [_tableView beginUpdates];
    [_tableView endUpdates];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
    if (!_beginTime.length) {
        [self showErrorHud:@"请填写送餐时间"];
        return;
    }
    
    WEAddress *a = nil;
    NSArray *array = [[WEAddressManager sharedInstance] allAddress];
    if (array.count) {
        int index = [[WEAddressManager sharedInstance] getSelectedIndex];
        if (index < array.count) {
            a = [array objectAtIndex:index];
        }
    }
    if (a == nil) {
        [self showErrorHud:@"请填写送餐地址"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在发送订单，请稍后...";
    [hud show:YES];
    
    NSString *UserCouponId = @"";
    if([WEGlobalData sharedInstance].selectedCouponId) {
        UserCouponId = [WEGlobalData sharedInstance].selectedCouponId;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *day;
    NSDate *date = [NSDate date];
    if (!_isToday) {
        date = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    }
    day = [formatter stringFromDate:date];
    NSString *time = [NSString stringWithFormat:@"%@-%@%@", day,
                      [_beginTime substringWithRange:NSMakeRange(0,2)],
                      [_beginTime substringWithRange:NSMakeRange(3,2)]];
    
    [WENetUtil UpdateOrderForCheckoutWithOrderId:_orderId
                                  DispatchMethod:_currentDispatchMethod
                             RequiredArrivalTime:time
                                         Message:CHECK_NULL_STRING(_messageContent)
                                    UserCouponId:UserCouponId
                          DispatchToAddressLine1:a.house
                          DispatchToAddressLine2:@""
                          DispatchToAddressLine3:@""
                                  DispatchToCity:a.cityName
                                  DispatchToState:a.stateName
                               DispatchToCountry:@"US"
                              DispatchToPostcode:a.postCode
                              DispatchToLatitude:@"12.18762"
                             DispatchToLongitude:@"-29.1349"
                              DispatchToContactName:a.personName
                             DispatchToPhoneNumber:a.phone
                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                             JSONModelError* error = nil;
                                             NSDictionary *dict = (NSDictionary *)responseObject;
                                             WEModelOrder *order = [[WEModelOrder alloc] initWithDictionary:[dict objectForKey:@"Order"] error:&error];
                                             if (error) {
                                                 NSLog(@"error %@", error);
                                             }
                                             NSLog(@"order id = %@", order.Id);
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (order.Id.length) {
                                                     [hud hide:YES afterDelay:0];
                                                     WEOrderPayViewController *c = [WEOrderPayViewController new];
                                                     c.order = order;
                                                     c.isToday = _isToday;
                                                     c.kitchenInfo = _kitchenInfo;
                                                     [self.navigationController pushViewController:c animated:YES];
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KITCHEN_ORDER_CHANGE object:nil];
                                                     
                                                 } else {
                                                     WEModelCommon *common = [[WEModelCommon alloc] initWithDictionary:dict error:nil];
                                                     hud.labelText = common.ResponseMessage;
                                                     [hud hide:YES afterDelay:1.5];
                                                 }
                                             });
                                             
                                             
                                         } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                             NSLog(@"failure %@", errorMsg);
                                             hud.labelText = errorMsg;
                                             [hud hide:YES afterDelay:1.5];
                                         }];

    
}


@end
