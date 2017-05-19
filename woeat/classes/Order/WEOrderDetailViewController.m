//
//  WEOrderDetailViewController.m
//  woeat
//
//  Created by liubin on 16/11/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderDetailViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "WEOrderDishListView.h"
#import "UIImageView+WebCache.h"
#import "WEBottomStatusBar.h"
#import "WEOrderPayViewController.h"
#import "WEMainTabBarController.h"
#import "WEModelOrder.h"
#import "WEModelGetConsumerKitchen.h"
#import "WEOrderstatus.h"
#import "WEModelClaimCoupon.h"
#import "WEHomeKitchenViewController.h"
#import "UmengStat.h"

#define TABLE_HEADER_HEIGHT  35
#define TABLE_ROW_HEIGHT  40

@interface WEOrderDetailViewController ()
{
    UIScrollView *_scrollView;
    
    WEOrderDishListView *_dishListView;
    MASConstraint *_dishListViewHeightConstraint;
    
    UITableView *_inputTableView;
    MASConstraint *_inputTableViewHeightConstraint;
    
    UIImageView *_imgView;
    UILabel *_kitchenName;
    UILabel *_orderId;
    UILabel *_orderDate;
    UILabel *_orderStatus;
    
    UILabel *_totalPay;
    WEBottomStatusBar *_bottomStatusBar;
    WEModelClaimCoupon *_coupon;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation WEOrderDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.returnKeyHandler = nil;
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDefault;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"订单详情";
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
    
    float offsetX = 15;
    float imageWidth = 70;
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(20);
        make.height.equalTo(imageWidth);
        make.width.equalTo(imageWidth);
    }];
    //NSString *s = @"http://doc.woeatapp.com/ui/resource/DummyImages/Dishes/02.jpg";
    //NSURL *url = [NSURL URLWithString:s];
    //[imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _imgView = imgView;
    
    float offsetLeft = COND_WIDTH_320(15, 10);
    UILabel *kitchenName = [UILabel new];
    kitchenName.numberOfLines = 1;
    kitchenName.textAlignment = NSTextAlignmentLeft;
    kitchenName.font = [UIFont boldSystemFontOfSize:15];
    kitchenName.textColor = DARK_ORANGE_COLOR;
    //kitchenName.text = @"飘湘满楼";
    [superView addSubview:kitchenName];
    [kitchenName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offsetLeft);
        make.top.equalTo(imgView.top);
    }];
    _kitchenName = kitchenName;

    UILabel *orderId = [UILabel new];
    orderId.numberOfLines = 1;
    orderId.textAlignment = NSTextAlignmentLeft;
    orderId.font = [UIFont systemFontOfSize:13];
    orderId.textColor = [UIColor blackColor];
    //orderId.text = @"订单号 102226";
    [superView addSubview:orderId];
    [orderId sizeToFit];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenName.left);
        make.top.equalTo(kitchenName.bottom).offset(20);
    }];
    _orderId = orderId;
    
    UILabel *orderDate = [UILabel new];
    orderDate.numberOfLines = 1;
    orderDate.textAlignment = NSTextAlignmentRight;
    orderDate.font = [UIFont systemFontOfSize:13];
    orderDate.textColor = [UIColor lightGrayColor];
    //orderDate.text = @"2016年10月20日 19:25";
    [superView addSubview:orderDate];
    [orderDate sizeToFit];
    [orderDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenName.left);
        make.top.equalTo(orderId.bottom).offset(10);
    }];
    _orderDate = orderDate;
    
    UILabel *orderStatus = [UILabel new];
    orderStatus.numberOfLines = 1;
    orderStatus.textAlignment = NSTextAlignmentRight;
    orderStatus.font = [UIFont systemFontOfSize:13];
    orderStatus.textColor = [UIColor redColor];
    //orderStatus.text = @"待支付";
    [superView addSubview:orderStatus];
    [orderStatus sizeToFit];
    [orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offsetX);
        make.centerY.equalTo(kitchenName.centerY);
    }];
    _orderStatus = orderStatus;
    
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    float tableHeight = TABLE_ROW_HEIGHT * 5 + TABLE_HEADER_HEIGHT * 6;
    if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        tableHeight = 0;
    }
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(15);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _inputTableViewHeightConstraint = make.height.equalTo(tableHeight);
    }];
    _inputTableView = tableView;
    
    WEOrderDishListView *dishListView = [WEOrderDishListView new];
    dishListView.showHeader = NO;
    [superView addSubview:dishListView];
    [dishListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputTableView.bottom).offset(10);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _dishListViewHeightConstraint = make.height.equalTo(0);
    }];
    _dishListView = dishListView;
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [superView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dishListView.bottom).offset(5);
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(0.5);
    }];
    
    UILabel *totalPay = [UILabel new];
    totalPay.numberOfLines = 1;
    totalPay.textAlignment = NSTextAlignmentRight;
    totalPay.font = [UIFont systemFontOfSize:13];
    totalPay.textColor = [UIColor blackColor];
    //totalPay.text = @"$100.00";
    [superView addSubview:totalPay];
    [totalPay sizeToFit];
    [totalPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(bottomLine.bottom).offset(5);
    }];
    _totalPay = totalPay;
    
    WEBottomStatusBar *bottomStatusBar = [[WEBottomStatusBar alloc] initWithFrame:CGRectZero];
    bottomStatusBar.statusBarType = WEBottomStatusBarType_Order;
    [superView addSubview:bottomStatusBar];
    [bottomStatusBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPay.bottom).offset(5);
        make.bottom.equalTo(superView.bottom);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo([bottomStatusBar getHeight]);
    }];
    //bottomStatusBar.leftLabel.text = @"订单金额 $95.00";
    //[bottomStatusBar.rightButton setTitle:@"去支付" forState:UIControlStateNormal];
    [bottomStatusBar.rightButton addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
    _bottomStatusBar = bottomStatusBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[WEMainTabBarController sharedInstance] setTabBarHidden:YES animated:NO];
    [self updateUI];
    [UmengStat pageEnter:UMENG_STAT_PAGE_ORDER_DETAIL];
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
    [UmengStat pageLeave:UMENG_STAT_PAGE_ORDER_DETAIL];
}

- (void)updateTableHeight
{
    if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        _inputTableViewHeightConstraint.equalTo(0);
    } else {
        _inputTableViewHeightConstraint.equalTo( _inputTableView.contentSize.height );
    }
    
    _dishListViewHeightConstraint.equalTo( _dishListView.tableView.contentSize.height );
    
}

- (void)updateUI
{
    NSString *s = _kitchenInfo.PortraitImageUrl;
    NSURL *url = [NSURL URLWithString:s];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _kitchenName.text = _kitchenInfo.Name;
    _orderId.text = [NSString stringWithFormat:@"订单号 %@", _order.Id];
    _orderDate.text = [WEUtil convertFullDateStringToSimple:_order.RequiredArrivalTime];
    _orderStatus.text = [WEOrderStatus getDesc:_order.OrderStatus];
    _dishListView.kitchenInfo = _kitchenInfo;
    _dishListView.order = _order;
    _totalPay.text = [NSString stringWithFormat:@"$%.2f",_order.PayableValue];
    _bottomStatusBar.leftLabel.text = [NSString stringWithFormat:@"订单金额 $%.2f", _order.PayableValue];
    if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNPAID]) {
        [_bottomStatusBar.rightButton setTitle:@"去支付" forState:UIControlStateNormal];
    } else if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        [_bottomStatusBar.rightButton setTitle:@"修改菜品" forState:UIControlStateNormal];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = @[@"就餐方式", @"送餐地址", @"就餐时间", @"给厨房捎句话", @"优惠券"];
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor lightGrayColor];
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 140);
    UIView *superView = bg;
    
    float offsetX = 15;
    UILabel *header = [UILabel new];
    header.numberOfLines = 1;
    header.textAlignment = NSTextAlignmentLeft;
    header.font = [UIFont systemFontOfSize:13];
    header.textColor = [UIColor blackColor];
    header.text = array[section];
    [superView addSubview:header];
    [header sizeToFit];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(10);
    }];

    return bg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return TABLE_HEADER_HEIGHT;
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor lightGrayColor];
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 140);
    UIView *superView = bg;
    
    float offsetX = 15;
    UILabel *header = [UILabel new];
    header.numberOfLines = 1;
    header.textAlignment = NSTextAlignmentLeft;
    header.font = [UIFont systemFontOfSize:13];
    header.textColor = [UIColor blackColor];
    header.text = @"订单详情";
    [superView addSubview:header];
    [header sizeToFit];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(10);
    }];
    
    return bg;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *superView = cell.contentView;
    
    float offsetX = 15;
    if (indexPath.section == 0) {
        UILabel *header = [UILabel new];
        header.numberOfLines = 1;
        header.textAlignment = NSTextAlignmentLeft;
        header.font = [UIFont systemFontOfSize:13];
        header.textColor = [UIColor blackColor];
        [superView addSubview:header];
        [header sizeToFit];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top).offset(10);
        }];
        if ([_order.DispatchMethod isEqualToString:@"DELIVER"]) {
            header.text = @"外送";
        } else if ([_order.DispatchMethod isEqualToString:@"PICKUP"]){
            header.text = @"自取";
        }
    
    } else if (indexPath.section == 1) {
        UILabel *header = [UILabel new];
        header.numberOfLines = 0;
        header.textAlignment = NSTextAlignmentLeft;
        header.font = [UIFont systemFontOfSize:13];
        header.textColor = [UIColor blackColor];
        [superView addSubview:header];
        [header sizeToFit];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top).offset(10);
        }];
        NSMutableString *s = [NSMutableString new];
        [s appendFormat:@"%@, %@, %@\n", _order.DispatchToAddressLine1, _order.DispatchToCity, _order.DispatchToState];
        [s appendFormat:@"%@ %@", _order.UserDisplayName, _order.ContactNumber];
        header.text = s;
    
    } else if (indexPath.section == 2) {
        UILabel *header = [UILabel new];
        header.numberOfLines = 1;
        header.textAlignment = NSTextAlignmentLeft;
        header.font = [UIFont systemFontOfSize:13];
        header.textColor = [UIColor blackColor];
        [superView addSubview:header];
        [header sizeToFit];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top).offset(10);
        }];
        header.text = [WEUtil convertFullDateStringToSimple:_order.RequiredArrivalTime];
        
    } else if (indexPath.section == 3) {
        UILabel *header = [UILabel new];
        header.numberOfLines = 1;
        header.textAlignment = NSTextAlignmentLeft;
        header.font = [UIFont systemFontOfSize:13];
        header.textColor = [UIColor blackColor];
        [superView addSubview:header];
        [header sizeToFit];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top).offset(10);
        }];
        if (_order.Message.length) {
            header.text = _order.Message;
        } else {
            header.text = @"无留言";
        }
    
    } else if (indexPath.section == 4) {
        UILabel *header = [UILabel new];
        header.numberOfLines = 1;
        header.textAlignment = NSTextAlignmentLeft;
        header.font = [UIFont systemFontOfSize:13];
        header.textColor = [UIColor blackColor];
        [superView addSubview:header];
        [header sizeToFit];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(superView.top).offset(10);
        }];
        float coupon = 0;
        NSString *couponId = nil;
        for(WEModelOrderLines *item in _order.Lines) {
            if ([item.LineType isEqualToString:@"COUPON"]) {
                coupon += item.UnitPrice * item.Quantity;
                couponId = item.UserCouponId;
            }
        }
        if (!coupon) {
            NSString *text = @"无优惠券";
            header.text = text;
        } else if (_coupon) {
            NSString *text = [NSString stringWithFormat:@"%@ %@",_coupon.UserCoupon.RuleValueDescription, _coupon.UserCoupon.RuleDescription];
            header.text = text;
            
        } else {
            NSString *couponValue = [NSString stringWithFormat:@"-$%.2f", coupon];
            header.text = [NSString stringWithFormat:@"优惠金额 $%@", couponValue];
            [WENetUtil GetUserCouponWithCouponId:couponId
                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                             JSONModelError* error = nil;
                                             NSDictionary *dict = (NSDictionary *)responseObject;
                                             WEModelClaimCoupon *model = [[WEModelClaimCoupon alloc] initWithDictionary:dict error:&error];
                                             if (error) {
                                                 NSLog(@"error %@", error);
                                             }
                                             _coupon = model;
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [_inputTableView reloadData];
                                                 [self updateTableHeight];
                                             });

                                         } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                             NSLog(@"error %@", errorMsg);
                                         }];
        }
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 55;
    }
    
    return TABLE_ROW_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)gotoPay:(UIButton *)button
{
    if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNPAID]) {
        UINavigationController *nav = self.navigationController;
        [nav popViewControllerAnimated:NO];
        WEOrderPayViewController *c = [WEOrderPayViewController new];
        c.order = _order;
        c.kitchenInfo = _kitchenInfo;
        c.isToday = _isToday;
        [nav pushViewController:c animated:YES];
        
    } else if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        UINavigationController *nav = self.navigationController;
        [nav popToRootViewControllerAnimated:NO];
        [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
        [WEMainTabBarController sharedInstance].selectedIndex = 0;
        UIViewController *c = [WEMainTabBarController sharedInstance].selectedViewController;
        if ([c isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)c popToRootViewControllerAnimated:NO];
            WEHomeKitchenViewController *kitchenViewController = [WEHomeKitchenViewController new];
            kitchenViewController.kitchenId = _order.KitchenId;
            [(UINavigationController *)c pushViewController:kitchenViewController animated:YES];
        }

    }
}


@end
