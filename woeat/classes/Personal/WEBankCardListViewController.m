//
//  WEBankCardListViewController.m
//  woeat
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEBankCardListViewController.h"
#import "WENetUtil.h"
#import "WEBankCardListCell.h"
#import "MBProgressHUD.h"
#import "WEBankCardEditViewController.h"
#import "WEModelGetMyCardList.h"
#import "WEModelCommon.h"
#import "WEGlobalData.h"
#import "WEBankCardUpdateViewController.h"
#import "UmengStat.h"


@interface WEBankCardListViewController ()
{
    UITableView *_tableView;
    UILabel *_emptyLabel;
    int _longPressRow;
    WEModelGetMyCardList *_modelGetCardList;
}
@end

@implementation WEBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _longPressRow = -1;
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
   
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WEBankCardListCell class] forCellReuseIdentifier:@"WEBankCardListCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPress];
    
    
    UILabel *empty = [UILabel new];
    empty.text = @"您还没有添加银行卡，请点击右上角按钮添加";
    empty.textColor = UICOLOR(100, 100, 100);
    empty.font = [UIFont systemFontOfSize:13];
    [superView addSubview:empty];
    [empty sizeToFit];
    [empty makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(superView.top).offset(150);
    }];
    _emptyLabel = empty;
    _emptyLabel.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addRightNavButton:@"添加" image:nil target:self selector:@selector(rightButtonTapped:)];
    [self loadAllCard];
    [UmengStat pageEnter:UMENG_STAT_PAGE_BANK_CARD_LIST];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_BANK_CARD_LIST];
}


- (void)loadAllCard
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
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
            
            _modelGetCardList = model;
            [WEGlobalData sharedInstance].curCardList = _modelGetCardList;
            
        } else {
            hud.labelText = model.ResponseMessage;
            [hud hide:YES afterDelay:1.5];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTable];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTable];
        });
    }];
    
}

- (void)reloadTable
{
    [_tableView reloadData];
    int count =  _modelGetCardList.CardList.count;
    if (count) {
        _emptyLabel.hidden = YES;
    } else {
        _emptyLabel.hidden = NO;
    }

}



- (void)rightButtonTapped:(UIButton *)button
{
    WEBankCardEditViewController *c = [WEBankCardEditViewController new];
    [self.navigationController pushViewController:c animated:YES];
}

- (WEModelGetMyCardListCardList *)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    return _modelGetCardList.CardList[indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count =  _modelGetCardList.CardList.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WEBankCardListCell";
    WEBankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WEBankCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    WEModelGetMyCardListCardList *model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int count =  _modelGetCardList.CardList.count;
    if (indexPath.row < count-1) {
        return CARD_CELL_HEIGHT;
    } else {
        return CARD_CELL_HEIGHT+20;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)setDefaultCard
{
    if (_longPressRow < 0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在设置默认银行卡，请稍后...";
    [hud show:YES];
    
    WEModelGetMyCardListCardList *model = [self getModelAtIndexPath:
                                           [NSIndexPath indexPathForRow:_longPressRow inSection:0]];
    
    [WENetUtil SetDefaultCardWithBankCardId:model.Id
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        JSONModelError* error = nil;
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        WEModelCommon *model = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                        if (error) {
                                            NSLog(@"error %@", error);
                                        }
                                        if (model.IsSuccessful) {
                                            [hud hide:YES afterDelay:0];
                                            [self loadAllCard];
                                            
                                        } else {
                                            hud.labelText = model.ResponseMessage;
                                            [hud hide:YES afterDelay:1.5];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self reloadTable];
                                        });
                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                        NSLog(@"errorMsg %@", errorMsg);
                                        hud.labelText = errorMsg;
                                        [hud hide:YES afterDelay:1.5];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self reloadTable];
                                        });

                                    }];
    
}

- (void)updateCard
{
    if (_longPressRow < 0) {
        return;
    }
    
    WEModelGetMyCardListCardList *model = [self getModelAtIndexPath:
                                           [NSIndexPath indexPathForRow:_longPressRow inSection:0]];

    WEBankCardUpdateViewController *c = [WEBankCardUpdateViewController new];
    c.model = model;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)deleteCard
{
    if (_longPressRow < 0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在删除银行卡，请稍后...";
    [hud show:YES];
    
    WEModelGetMyCardListCardList *model = [self getModelAtIndexPath:
                                           [NSIndexPath indexPathForRow:_longPressRow inSection:0]];

    [WENetUtil DeleteCardWithBankCardId:model.Id
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        JSONModelError* error = nil;
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        WEModelCommon *model = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
                                        if (error) {
                                            NSLog(@"error %@", error);
                                        }
                                        if (model.IsSuccessful) {
                                            [hud hide:YES afterDelay:0];
                                            [self loadAllCard];
                                            
                                        } else {
                                            hud.labelText = model.ResponseMessage;
                                            [hud hide:YES afterDelay:1.5];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self reloadTable];
                                        });
                                    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                        NSLog(@"errorMsg %@", errorMsg);
                                        hud.labelText = errorMsg;
                                        [hud hide:YES afterDelay:1.5];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self reloadTable];
                                        });
                                        
                                    }];

}

-(void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:_tableView];
        NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:point];
        if(indexPath == nil)
            return ;
        _longPressRow = indexPath.row;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"设为默认卡"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self setDefaultCard];
                                                       }];
        [action setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:action];
        
        action = [UIAlertAction actionWithTitle:@"编辑"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self updateCard];
                                                       }];
        [action setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:action];
        
        
        action = [UIAlertAction actionWithTitle:@"删除"
                                         style:UIAlertActionStyleDestructive
                                       handler:^(UIAlertAction * _Nonnull action) {
                                           [self deleteCard];
                                       }];
        [alertController addAction:action];
        
        
        action = [UIAlertAction actionWithTitle:@"取消"
                                          style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * _Nonnull action) {
                                            _longPressRow = -1;
                                        }];
        [action setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
