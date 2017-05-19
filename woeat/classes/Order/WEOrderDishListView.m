//
//  WEOrderDishListView.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderDishListView.h"
#import "WEUtil.h"
#import "WEOrderDishCell.h"
#import "UIImageView+WebCache.h"
#import "WEModelOrder.h"
#import "WEOrderPayViewController.h"
#import "WEModelCommon.h"
#import "WEModelGetConsumerKitchen.h"

@interface WEOrderDishListView()
{
    
    UILabel *_orderId;
    UILabel *_orderDate;
    UIImageView *_imgView;
    UILabel *_kitchenName;
    UILabel *_diliver;
    UILabel *_price;
}

@end

@implementation WEOrderDishListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showHeader = YES;
        
        UIView *superView = self;
        
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[WEOrderDishCell class] forCellReuseIdentifier:@"WEOrderDishCell"];

        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _tableView = tableView;
        
    }
    return self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _order.Lines.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_showHeader) {
        return 110;
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor clearColor];
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 140);
    UIView *superView = bg;
    
    float offsetX = 15;
    UILabel *orderId = [UILabel new];
    orderId.numberOfLines = 1;
    orderId.textAlignment = NSTextAlignmentLeft;
    orderId.font = [UIFont systemFontOfSize:13];
    orderId.textColor = [UIColor blackColor];
    //orderId.text = @"订单号 102226";
    [superView addSubview:orderId];
    [orderId sizeToFit];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(0);
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
        make.centerY.equalTo(orderId.centerY);
        make.right.equalTo(superView.right).offset(-offsetX);
    }];
    _orderDate = orderDate;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(orderId.bottom).offset(10);
        make.height.equalTo(0.5);
    }];
    
    float imageWidth = 70;
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.left);
        make.top.equalTo(line.bottom).offset(5);
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
    
    UILabel *diliver = [UILabel new];
    diliver.numberOfLines = 1;
    diliver.textAlignment = NSTextAlignmentLeft;
    diliver.font = [UIFont systemFontOfSize:11];
    diliver.textColor = [UIColor blackColor];
    //diliver.text = @"配送";
    [superView addSubview:diliver];
    [diliver sizeToFit];
    [diliver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenName.left);
        make.top.equalTo(kitchenName.bottom).offset(10);
    }];
    _diliver = diliver;
    
    UILabel *price = [UILabel new];
    price.numberOfLines = 1;
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont systemFontOfSize:11];
    price.textColor = [UIColor blackColor];
    //price.text = @"总额: $36.00";
    [superView addSubview:price];
    [price sizeToFit];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(diliver.right).offset(20);
        make.centerY.equalTo(diliver.centerY);
    }];
    _price = price;
    return bg;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEOrderDishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEOrderDishCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [WEOrderDishCell new];
    }
    [cell setModel:[_order.Lines objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)setShowHeader:(BOOL)showHeader
{
    _showHeader = showHeader;
    [_tableView reloadData];
}

- (void)updateUI
{
    _orderId.text = [NSString stringWithFormat:@"订单号 %@", _order.Id];
    
    NSDateFormatter *input = [[NSDateFormatter alloc] init];
    [input setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [input dateFromString:_order.RequiredArrivalTime];
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *time = [output stringFromDate:date];
    _orderDate.text = time;
    if ([_order.DispatchMethod isEqualToString:@"DELIVER"]) {
        _diliver.text = @"外送";
    } else {
        _diliver.text = @"自取";
    }
    _price.text = [NSString stringWithFormat:@"总额: $%.2f", _order.PayableValue];
    
    NSURL *url = [NSURL URLWithString:_kitchenInfo.PortraitImageUrl];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _kitchenName.text = _kitchenInfo.Name;
}

- (void)setOrder:(WEModelOrder *)order
{
    _order = order;
    [_tableView reloadData];
    [self performSelector:@selector(updateUI) withObject:nil afterDelay:0];
}

- (void)setKitchenInfo:(WEModelGetConsumerKitchen *)kitchenInfo
{
    _kitchenInfo = kitchenInfo;
    [_tableView reloadData];
    [self performSelector:@selector(updateUI) withObject:nil afterDelay:0];
}

@end
