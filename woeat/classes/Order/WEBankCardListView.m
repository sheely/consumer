//
//  WEBankCardListView.m
//  woeat
//
//  Created by liubin on 17/3/18.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEBankCardListView.h"
#import "WEModelGetMyCardList.h"
#import "MBProgressHUD.h"
#import "WEGlobalData.h"
#import "WENetUtil.h"

#define CELL_HEIGHT  35

#define TAG_IMAGE_SELECT   100
#define TAG_LABEL          200

@interface WEBankCardListView()
{
    UITableView *_tableView;
    int _selectIndex;
}
@end


@implementation WEBankCardListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superView = self;
        
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _tableView = tableView;
        
        UILabel *empty = [UILabel new];
        empty.text = @"您还没有添加银行卡\n请点击我的->我的银行卡,添加常用银行卡";
        empty.textColor = UICOLOR(100, 100, 100);
        empty.font = [UIFont systemFontOfSize:13];
        empty.numberOfLines = 0;
        empty.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:empty];
        [empty makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.centerX);
            make.centerY.equalTo(superView.centerY);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
        }];
        _emptyLabel = empty;
        _emptyLabel.hidden = YES;
        
        [self loadAllCard];
        
    }
    return self;
    
}

- (void)loadAllCard
{
    if ([WEGlobalData sharedInstance].curCardList) {
        return;
    }
    
    _emptyLabel.hidden = YES;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        //hud.yOffset = -30;
        [self addSubview:hud];
    }
    hud.labelText = @"正在获取银行卡列表，请稍后...";
    [hud show:YES];
    
    [WENetUtil GetMyCardListWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetMyCardList *model = [[WEModelGetMyCardList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (model.IsSuccessful) {
            [hud hide:YES afterDelay:0];
            [WEGlobalData sharedInstance].curCardList = model;
            
        } else {
            hud.labelText = model.ResponseMessage;
            [hud hide:YES afterDelay:1.5];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            if (!model.CardList.count) {
                _emptyLabel.hidden = NO;
            }
            [_parentView heightChanged];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
    
}

- (WEModelGetMyCardListCardList *)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    WEModelGetMyCardList *model = [WEGlobalData sharedInstance].curCardList;
    return model.CardList[indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WEModelGetMyCardList *model = [WEGlobalData sharedInstance].curCardList;
    return model.CardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *superView = cell.contentView;
    
    UIImageView *imgView = [UIImageView new];
    imgView.tag = TAG_IMAGE_SELECT;
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(15);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(15);
        make.height.equalTo(15);
    }];
    if (_selectIndex == indexPath.row) {
        imgView.image = [UIImage imageNamed:@"circle2_select"];
    } else {
        imgView.image = [UIImage imageNamed:@"circle2_normal"];
    }
    
    UILabel *label = [UILabel new];
    label.tag = TAG_LABEL;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [superView addSubview:label];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(20);
        make.centerY.equalTo(superView.centerY);
    }];
    WEModelGetMyCardListCardList *model = [self getModelAtIndexPath:indexPath];
    label.text = model.Name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    [_tableView reloadData];
}

- (float)getHeight
{
    WEModelGetMyCardList *model = [WEGlobalData sharedInstance].curCardList;
    float height =  model.CardList.count * CELL_HEIGHT + 5;
    if (model.CardList.count) {
        if (height < 60) {
            height =  60;
        }
    } else {
        if (height < 200) {
            height =  200;
        }
    }
    
    return height;
}

- (WEModelGetMyCardListCardList *)getSelectedCardModel
{
    WEModelGetMyCardList *list = [WEGlobalData sharedInstance].curCardList;
    if (_selectIndex >=0 && _selectIndex < list.CardList.count) {
        WEModelGetMyCardListCardList *model = list.CardList[_selectIndex];
        return model;
    }
    return nil;
}

@end
