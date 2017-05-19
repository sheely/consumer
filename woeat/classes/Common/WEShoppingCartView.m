//
//  WEShoppingCartView.m
//  woeat
//
//  Created by liubin on 16/12/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEShoppingCartView.h"
#import "WEShoppingCartCell.h"
#import "WEModelGetTodayList.h"
#import "WEUtil.h"
#import "WEShoppingCartManager.h"
#import "WENetUtil.h"
#import "MBProgressHUD.h"
#import "WEModelOrder.h"
#import "WEOrderConfirmViewController.h"

#define TAG_CELL_ADD_BUTTON_START   1000
#define TAG_CELL_ADD_BUTTON_END     2000

#define TAG_CELL_MINUS_BUTTON_START   5000
#define TAG_CELL_MINUS_BUTTON_END     6000


@interface WEShoppingCartView()
{
    UIButton *_cleanButton;
    UITableView *_dishTableView;
    //MASConstraint *_dishTableViewHeightConstraint;
    
    NSMutableDictionary *_numberDict; //dish id -> number
    NSMutableDictionary *_itemDict; //dish id -> item
    
}
@property(nonatomic, strong, readwrite) UILabel *leftLabel;
@property(nonatomic, strong, readwrite) UILabel *middleLabel;
@property(nonatomic, strong, readwrite) UIButton *rightButton;

@end

@implementation WEShoppingCartView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberDict = [NSMutableDictionary new];
        _itemDict = [NSMutableDictionary new];
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *superView = self;
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = DARK_ORANGE_COLOR;
        [superView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superView.bottom);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.height.equalTo(40);
        }];
        
        superView = bottomView;
        UILabel *leftLabel = [UILabel new];
        leftLabel.numberOfLines = 1;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = UICOLOR(193, 193, 193);
        [superView addSubview:leftLabel];
        [leftLabel sizeToFit];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.left.equalTo(superView.left).offset(20);
        }];
        _leftLabel = leftLabel;
        
        UILabel *middleLabel = [UILabel new];
        middleLabel.numberOfLines = 1;
        middleLabel.textAlignment = NSTextAlignmentCenter;
        middleLabel.font = [UIFont systemFontOfSize:13];
        middleLabel.textColor = UICOLOR(193, 193, 193);
        [superView addSubview:middleLabel];
        [middleLabel sizeToFit];
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.centerX.equalTo(superView.centerX);
            make.left.equalTo(superView.left).offset(10);
            make.right.equalTo(superView.right).offset(-10);
        }];
        _middleLabel = middleLabel;
        
        UIButton *rightButton = [UIButton new];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:rightButton];
        [rightButton setTitle:@"选好了" forState:UIControlStateNormal];
        [rightButton sizeToFit];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-20);
            make.centerY.equalTo(superView.centerY);
        }];
        _rightButton = rightButton;
        
        UIButton *cleanButton = [UIButton new];
        [cleanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cleanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        cleanButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        cleanButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [cleanButton addTarget:self action:@selector(cleanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:cleanButton];
        [cleanButton setTitle:@"清空" forState:UIControlStateNormal];
        [cleanButton sizeToFit];
        [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightButton.left).offset(-20);
            make.centerY.equalTo(superView.centerY);
        }];
        _cleanButton = cleanButton;
        
        superView = self;
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = YES;
        [tableView registerClass:[WEShoppingCartCell class] forCellReuseIdentifier:@"WEShoppingCartCell"];
        [superView addSubview:tableView];
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(0);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            //_dishTableViewHeightConstraint = make.height.equalTo(0);
            make.bottom.equalTo(bottomView.top);
        }];
        _dishTableView = tableView;
        
    }
    return self;
}

- (float)getHeight
{
    return 40 + _dishTableView.contentSize.height;
}

- (void)updateBottomText
{
    float total = 0;
    for(NSString *itemId in _numberDict) {
        WEModelGetTodayListItemList *item = [_itemDict objectForKey:itemId];
        float price = item.UnitPrice;
        
        NSNumber *number = [_numberDict objectForKey:item.Id];
        total += price * number.integerValue;
    }
    
    if (total) {
        _leftLabel.text = [NSString stringWithFormat:@"订单金额 $%.2f", total];
        _rightButton.hidden = NO;
        _cleanButton.hidden = NO;
    } else {
        _leftLabel.text = @"订单金额 $0.00";
        _rightButton.hidden = YES;
        _cleanButton.hidden = YES;
    }

}

- (void)updateTotalHeight
{
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo( [self getHeight] );
    }];
}

- (void)setAllList:(WEModelGetTodayList *)allList
{
    _allList = allList;
    [_itemDict removeAllObjects];
    for(WEModelGetTodayListItemList *item in _allList.ItemList) {
        [_itemDict setObject:item forKey:item.Id];
    }
}

- (void)loadItems
{
    [_numberDict removeAllObjects];
    
    WEShoppingCartManager *manager = [WEShoppingCartManager sharedInstance];
    NSDictionary *loaded = nil;
    if (_isToday) {
        loaded = [manager loadKitchenCartToday:_kitchenId];
    } else {
        loaded = [manager loadKitchenCartTomorrow:_kitchenId];
    }
    
    for(NSString *itemId in loaded) {
        if ([_itemDict objectForKey:itemId]) {
            WEModelGetTodayListItemList *item = [_itemDict objectForKey:itemId];
            NSNumber *count = loaded[itemId];
            if (item.CurrentAvailability > 0) {
                if (item.CurrentAvailability < count.integerValue) {
                    count = @(item.CurrentAvailability);
                }
                [_numberDict setObject:loaded[itemId] forKey:itemId];
                [_itemDelegate itemAddOrMinus:itemId cartView:self];
            }
        } else {
            NSLog(@"item error, can not find item %@", itemId);
        }
    }
    [self updateBottomText];
    [_dishTableView reloadData];
}

- (void)saveItems
{
    WEShoppingCartManager *manager = [WEShoppingCartManager sharedInstance];
    if (_isToday) {
        [manager saveKitchenCartToday:_kitchenId data:_numberDict];
    } else {
        [manager saveKitchenCartTomorrow:_kitchenId data:_numberDict];
    }
}

- (void)addItem:(NSString *)itemId
{
    if (![_itemDict objectForKey:itemId]) {
        NSLog(@"addItem error, can not find item %@", itemId);
        return;
    }
    WEModelGetTodayListItemList *item = [_itemDict objectForKey:itemId];
    
    NSNumber *number = [_numberDict objectForKey:itemId];
    if (!number.integerValue) {
        if (item.CurrentAvailability >= 1) {
            [_numberDict setObject:@(1) forKey:itemId];
            [_itemDelegate itemAddOrMinus:item.Id cartView:self];
        }
    } else {
        int i = number.integerValue;
        if (item.CurrentAvailability >= i+1) {
            [_numberDict setObject:@(i+1) forKey:itemId];
            [_itemDelegate itemAddOrMinus:item.Id cartView:self];
        }
    }
    [self updateBottomText];
    [_dishTableView reloadData];
    [self updateTotalHeight];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_numberDict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEShoppingCartCell"];
    if (!cell) {
        cell = [[WEShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEShoppingCartCell"];
    }
    
    NSArray *keys = [[_numberDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *itemId = [keys objectAtIndex:indexPath.row];
    WEModelGetTodayListItemList *item = [_itemDict objectForKey:itemId];
    cell.dishNameLabel.text = item.Name;
    
    float price = item.UnitPrice;
    NSNumber *number = [_numberDict objectForKey:itemId];
    cell.moneyLabel.text = [NSString stringWithFormat:@"$%.2f", price * number.integerValue];
    cell.countLabel.text = [NSString stringWithFormat:@"%d", number.integerValue];
    [cell.addButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [cell.minusButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [cell.addButton addTarget:self action:@selector(cellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusButton addTarget:self action:@selector(cellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = TAG_CELL_ADD_BUTTON_START + indexPath.row;
    cell.minusButton.tag = TAG_CELL_MINUS_BUTTON_START + indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_numberDict count]) {
        return 20;
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = DARK_ORANGE_COLOR;
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 40);
    return bg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (void)cellButtonTapped:(UIButton *)button
{
    if (button.tag >= TAG_CELL_ADD_BUTTON_START && button.tag <= TAG_CELL_ADD_BUTTON_END) {
        int row = button.tag - TAG_CELL_ADD_BUTTON_START;
        
        NSArray *keys = [[_numberDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSString *itemId = [keys objectAtIndex:row];
        NSNumber *number = [_numberDict objectForKey:itemId];
        WEModelGetTodayListItemList *item = [_itemDict objectForKey:itemId];
        if (item.CurrentAvailability >= number.integerValue + 1) {
            number = @(number.integerValue + 1);
            [_numberDict setObject:number forKey:itemId];
            [_itemDelegate itemAddOrMinus:item.Id cartView:self];
        }
        
    } else if (button.tag >= TAG_CELL_MINUS_BUTTON_START && button.tag <= TAG_CELL_MINUS_BUTTON_END) {
        int row = button.tag - TAG_CELL_MINUS_BUTTON_START;
        
        NSArray *keys = [[_numberDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSString *itemId = [keys objectAtIndex:row];
        NSNumber *number = [_numberDict objectForKey:itemId];
        if (number.integerValue > 1) {
            number = @(number.integerValue - 1);
            [_numberDict setObject:number forKey:itemId];
        } else {
            [_numberDict removeObjectForKey:itemId];
        }
        [_itemDelegate itemAddOrMinus:itemId cartView:self];
    }
    
    [self updateBottomText];
    [_dishTableView reloadData];
    [self updateTotalHeight];
}

- (void)cleanButtonTapped:(UIButton *)button
{
    [_numberDict removeAllObjects];
    [self updateBottomText];
    [_dishTableView reloadData];
    [self updateTotalHeight];
}

- (void)rightButtonTapped:(UIButton *)button
{
    int count = _numberDict.count;
    NSMutableArray *ItemIdArray = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray *UnitPriceArray = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray *QuantityArray = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSString *itemId in _numberDict) {
        WEModelGetTodayListItemList *item = [_itemDict objectForKey:itemId];
        float price = item.UnitPrice;
        NSNumber *number = [_numberDict objectForKey:item.Id];
        [ItemIdArray addObject:itemId];
        [UnitPriceArray addObject:[NSString stringWithFormat:@"%.2f", price]];
        [QuantityArray addObject:[NSString stringWithFormat:@"%d", number.integerValue]];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:_parentController.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:_parentController.view];
        //hud.yOffset = -30;
        [_parentController.view addSubview:hud];
    }
    hud.labelText = @"正在发送订单信息，请稍后...";
    [hud show:YES];
    
    [WENetUtil SubmitOrderWithKitchenId:_kitchenId
                                isToday:_isToday
                            itemIdArray:ItemIdArray
                         unitPriceArray:UnitPriceArray
                          quantityArray:QuantityArray
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [hud hide:YES afterDelay:0];
                                    JSONModelError* error = nil;
                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                    WEModelOrder *order = [[WEModelOrder alloc] initWithDictionary:[dict objectForKey:@"Order"] error:&error];
                                    if (error) {
                                        NSLog(@"error %@", error);
                                    }
                                    NSLog(@"order id = %@", order.Id);
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        WEOrderConfirmViewController *c = [WEOrderConfirmViewController new];
                                        c.kitchenInfo = _kitchenInfo;
                                        c.isToday = _isToday;
                                        c.orderId = order.Id;
                                        [_parentController.navigationController pushViewController:c animated:YES];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KITCHEN_ORDER_CHANGE object:nil];
                                        
                                    });
                                    
                                    
                                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                    NSLog(@"failure %@", errorMsg);
                                    hud.labelText = errorMsg;
                                    [hud hide:YES afterDelay:1.5];
                                }];
}

- (int)getItemSelectCount:(NSString *)itemId
{
    NSNumber *number = [_numberDict objectForKey:itemId];
    return number.integerValue;
        
}

@end
