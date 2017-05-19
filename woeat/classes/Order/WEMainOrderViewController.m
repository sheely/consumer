//
//  WEMainOrderViewController.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEMainOrderViewController.h"
#import "WEUtil.h"
#import "UIImageView+WebCache.h"
#import "WESegmentControl.h"
#import "WEMainOrderViewCell.h"
#import "WEMainTabBarController.h"
#import "WENetUtil.h"
#import "WEModelGetMyOrderList.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "WEPersonalCommentViewController.h"
#import "UmengStat.h"

#define PAGE_COUNT 10

@interface WEMainOrderViewController ()
{
    WESegmentControl *_segment;
    UITableView *_tableView;
    
    NSMutableArray *_orderListArray[3]; //3 array of WEModelGetMyOrderList
    int _curPage[3];//from 1
    
    WEPersonalCommentViewController *_tmpController;
}
@end

@implementation WEMainOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的订单";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    WESegmentControl *segment = [[WESegmentControl alloc] initWithItems:@[@"进行中", @"待评价", @"已完成"]];
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [superView addSubview:segment];
    [segment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(30);
    }];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:14], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                nil];
    [segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
     NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    _segment = segment;
    
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WEMainOrderViewCell class] forCellReuseIdentifier:@"WEMainOrderViewCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.bottom).offset(5);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];

    _tmpController = [WEPersonalCommentViewController new];
    [self.view addSubview:_tmpController.view];
    [_tmpController.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.top);
        make.left.equalTo(tableView.left);
        make.bottom.equalTo(tableView.bottom);
        make.right.equalTo(tableView.right);
    }];
    _tmpController.view.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderChanged:) name:NOTIFICATION_KITCHEN_ORDER_CHANGE object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
    [self loadDataIfNeeded:_segment.selectedSegmentIndex];
    [UmengStat pageEnter:UMENG_STAT_PAGE_ORDER_LIST];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_ORDER_LIST];
}

- (void)initData
{
    for(int i=0; i<3; i++) {
        _curPage[i] = 1;
        _orderListArray[i] = [NSMutableArray new];
    }
}

- (void)realLoadData:(int)index
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取订单，请稍后...";
    [hud show:YES];
    
    if (index == 0) {
        [WENetUtil GetMyOrderListInProgressWithPageIndex:_curPage[index]
            Pagesize:PAGE_COUNT
            success:^(NSURLSessionDataTask *task, id responseObject) {
                
                JSONModelError* error = nil;
                NSDictionary *dict = (NSDictionary *)responseObject;
                WEModelGetMyOrderList *model = [[WEModelGetMyOrderList alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error %@, model %p", error, model);
                }
                if (!model.IsSuccessful) {
                    hud.labelText = model.ResponseMessage;
                    [hud hide:YES afterDelay:1.5];
                    return;
                }
                
                NSMutableArray *total = _orderListArray[index];
                if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                    [total addObject:model];
                    _curPage[index]++;
                } else {
                    NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                }
                
                [_tableView reloadData];
                [self updateAllLoadedState];
                NSLog(@"GetMyOrderListInProgressWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.OrderList.count, index);
                [hud hide:YES afterDelay:0];
            
            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                NSLog(@"failure %@", errorMsg);
                hud.labelText = errorMsg;
                [hud hide:YES afterDelay:1.5];
           }];
        
    } else if (index == 1) {
        [WENetUtil GetMyOrderListToCommentWithPageIndex:_curPage[index]
                                               Pagesize:PAGE_COUNT
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    JSONModelError* error = nil;
                    NSDictionary *dict = (NSDictionary *)responseObject;
                    WEModelGetMyOrderList *model = [[WEModelGetMyOrderList alloc] initWithDictionary:dict error:&error];
                    if (error) {
                        NSLog(@"error %@", error);
                    }
                    if (!model.IsSuccessful) {
                        hud.labelText = model.ResponseMessage;
                        [hud hide:YES afterDelay:1.5];
                        return;
                    }
                    
                    NSMutableArray *total = _orderListArray[index];
                    if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                        [total addObject:model];
                        _curPage[index]++;
                    } else {
                        NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                    }
                    
                    [_tableView reloadData];
                    [self updateAllLoadedState];
                    NSLog(@"GetMyOrderListToCommentWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.OrderList.count, index);
                    [hud hide:YES afterDelay:0];
                    
                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                    NSLog(@"failure %@", errorMsg);
                    hud.labelText = errorMsg;
                    [hud hide:YES afterDelay:1.5];
                }];
        
    } else {
        [WENetUtil GetMyOrderListCompletedWithPageIndex:_curPage[index]
                                               Pagesize:PAGE_COUNT
            success:^(NSURLSessionDataTask *task, id responseObject) {
                
                JSONModelError* error = nil;
                NSDictionary *dict = (NSDictionary *)responseObject;
                WEModelGetMyOrderList *model = [[WEModelGetMyOrderList alloc] initWithDictionary:dict error:&error];
                if (error) {
                    NSLog(@"error %@", error);
                }
                if (!model.IsSuccessful) {
                    hud.labelText = model.ResponseMessage;
                    [hud hide:YES afterDelay:1.5];
                    return;
                }
                
                NSMutableArray *total = _orderListArray[index];
                if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                    [total addObject:model];
                    _curPage[index]++;
                } else {
                    NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                }
                
                [_tableView reloadData];
                [self updateAllLoadedState];
                NSLog(@"GetMyOrderListCompletedWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.OrderList.count, index);
                [hud hide:YES afterDelay:0];
                
            } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                NSLog(@"failure %@", errorMsg);
                hud.labelText = errorMsg;
                [hud hide:YES afterDelay:1.5];
            }];
    }
}

- (void)reloadAllData:(int)index
{
    _curPage[index] = 1;
    [_orderListArray[index] removeAllObjects];
    [self updateAllLoadedState];
    [self realLoadData:index];
}

- (void)loadMoreData:(int)index
{
    [self realLoadData:index];
}

- (NSNumber *)isAllLoaded:(int)index
{
    NSMutableArray *total = _orderListArray[index];
    if(total.count) {
        WEModelGetMyOrderList *model = [total lastObject];
        if (model.PageFilter.PageIndex >= model.PageFilter.TotalPages)
            return @YES;
    }
    return @NO;
}

- (BOOL)loadDataIfNeeded:(int)index
{
    NSMutableArray *total = _orderListArray[index];
    if(total.count) {
        [_tableView reloadData];
       // [self loadDataSilent:index];
        [self performSelector:@selector(loadDataSilent:) withObject:@(index) afterDelay:0.1];
        return YES;
    } else {
        [_tableView.mj_header beginRefreshing];
        return NO;
    }
}

- (void)loadDataSilent:(NSNumber *)n
{
    int index = n.integerValue;
    _curPage[index] = 1;
    [_orderListArray[index] removeAllObjects];
    [self updateAllLoadedState];
   
    if (index == 0) {
        [WENetUtil GetMyOrderListInProgressWithPageIndex:_curPage[index]
                                                Pagesize:PAGE_COUNT
                                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                                     
                                                     JSONModelError* error = nil;
                                                     NSDictionary *dict = (NSDictionary *)responseObject;
                                                     WEModelGetMyOrderList *model = [[WEModelGetMyOrderList alloc] initWithDictionary:dict error:&error];
                                                     if (error) {
                                                         NSLog(@"error %@, model %p", error, model);
                                                     }
                                                     if (!model.IsSuccessful) {                                                         return;
                                                     }
                                                     
                                                     NSMutableArray *total = _orderListArray[index];
                                                     if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                         [total addObject:model];
                                                         _curPage[index]++;
                                                     } else {
                                                         NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                     }
                                                     
                                                     [_tableView reloadData];
                                                     [self updateAllLoadedState];
                                                     NSLog(@"GetMyOrderListInProgressWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.OrderList.count, index);
                                                     
                                                 } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                     NSLog(@"failure %@", errorMsg);
                                             
                                                 }];
        
    } else if (index == 1) {
        [WENetUtil GetMyOrderListToCommentWithPageIndex:_curPage[index]
                                               Pagesize:PAGE_COUNT
                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                    
                                                    JSONModelError* error = nil;
                                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                                    WEModelGetMyOrderList *model = [[WEModelGetMyOrderList alloc] initWithDictionary:dict error:&error];
                                                    if (error) {
                                                        NSLog(@"error %@", error);
                                                    }
                                                    if (!model.IsSuccessful) {
                                                        return;
                                                    }
                                                    
                                                    NSMutableArray *total = _orderListArray[index];
                                                    if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                        [total addObject:model];
                                                        _curPage[index]++;
                                                    } else {
                                                        NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                    }
                                                    
                                                    [_tableView reloadData];
                                                    [self updateAllLoadedState];
                                                    NSLog(@"GetMyOrderListToCommentWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.OrderList.count, index);
                                                   
                                                    
                                                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                    NSLog(@"failure %@", errorMsg);
                                                  
                                                }];
        
    } else {
        [WENetUtil GetMyOrderListCompletedWithPageIndex:_curPage[index]
                                               Pagesize:PAGE_COUNT
                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                    
                                                    JSONModelError* error = nil;
                                                    NSDictionary *dict = (NSDictionary *)responseObject;
                                                    WEModelGetMyOrderList *model = [[WEModelGetMyOrderList alloc] initWithDictionary:dict error:&error];
                                                    if (error) {
                                                        NSLog(@"error %@", error);
                                                    }
                                                    if (!model.IsSuccessful) {
                                                        return;
                                                    }
                                                    
                                                    NSMutableArray *total = _orderListArray[index];
                                                    if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageFilter.PageIndex) {
                                                        [total addObject:model];
                                                        _curPage[index]++;
                                                    } else {
                                                        NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageFilter.PageIndex);
                                                    }
                                                    
                                                    [_tableView reloadData];
                                                    [self updateAllLoadedState];
                                                    NSLog(@"GetMyOrderListCompletedWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.OrderList.count, index);
                                                
                                                    
                                                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                    NSLog(@"failure %@", errorMsg);
                                               
                                                }];
    }


}

- (void)downPull
{
    [self reloadAllData:_segment.selectedSegmentIndex];
    [_tableView.mj_header endRefreshing];
}

- (void)upPull
{
    if ([[self upPullFinished] boolValue]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadMoreData:_segment.selectedSegmentIndex];
        [_tableView.mj_footer endRefreshing];
    }
    
}

- (NSNumber *)upPullFinished
{
    return [self isAllLoaded:_segment.selectedSegmentIndex];
}

- (void)updateAllLoadedState
{
    if (![[self upPullFinished] boolValue]) {
        [_tableView.mj_footer resetNoMoreData];
    } else {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (void)segmentValueChanged:(id)sender
{
    if (_segment.selectedSegmentIndex == 2) {
        _tmpController.view.hidden = NO;
        _tableView.hidden = YES;
        [_tmpController viewWillAppear:YES];
        return;
    } else {
        _tmpController.view.hidden = YES;
        _tableView.hidden = NO;
    }
    
    [self updateAllLoadedState];
    [self loadDataIfNeeded:_segment.selectedSegmentIndex];
}

- (id)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelGetMyOrderList *model in _orderListArray[_segment.selectedSegmentIndex]) {
        row -= model.OrderList.count;
        if (row < 0) {
            return model.OrderList[row + model.OrderList.count];
        }
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row = 0;
    for(WEModelGetMyOrderList *model in _orderListArray[_segment.selectedSegmentIndex]) {
        row += model.OrderList.count;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WEMainOrderViewCell";
    WEMainOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WEMainOrderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    cell.controller = self;
    if (_segment.selectedSegmentIndex == 0) {
        cell.type = WEMainOrderViewCellType_ON_GOING;
    } else if (_segment.selectedSegmentIndex == 1) {
        cell.type = WEMainOrderViewCellType_WAIT_COMMENT;
    } else {
        cell.type = WEMainOrderViewCellType_FINISHED;
    }
    id model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WEMainOrderViewCell getHeightWithType:_segment.selectedSegmentIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)orderChanged:(NSNotification *)notif
{
    [self loadDataSilent:@(_segment.selectedSegmentIndex)];
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
