//
//  WESingleStateOrderViewController.m
//  woeat
//
//  Created by liubin on 17/1/4.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WESingleStateOrderViewController.h"
#import "WEMainOrderViewCell.h"
#import "WEMainTabBarController.h"
#import "WENetUtil.h"
#import "WEModelGetMyOrderList.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

#define PAGE_COUNT 10

@interface WESingleStateOrderViewController ()
{
    UITableView *_tableView;
    
    NSMutableArray *_orderListArray; //array of WEModelGetMyOrderList
    int _curPage;//from 1
}
@end


@implementation WESingleStateOrderViewController
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
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WEMainOrderViewCell class] forCellReuseIdentifier:@"WEMainOrderViewCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
    [self loadDataIfNeeded];
}


- (void)initData
{
    _curPage = 1;
    _orderListArray = [NSMutableArray new];

}

- (void)realLoadData
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取订单，请稍后...";
    [hud show:YES];
    
    if (_isOngoingState) {
        [WENetUtil GetMyOrderListInProgressWithPageIndex:_curPage
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
                                                     
                                                     NSMutableArray *total = _orderListArray;
                                                     if ([total count] == _curPage-1 && _curPage == model.PageFilter.PageIndex) {
                                                         [total addObject:model];
                                                         _curPage++;
                                                     } else {
                                                         NSLog(@"something error, %d, %d, %d", [total count], _curPage, model.PageFilter.PageIndex);
                                                     }
                                                     
                                                     [_tableView reloadData];
                                                     [self updateAllLoadedState];
                                                     NSLog(@"GetMyOrderListInProgressWithPageIndex, page %d, items count %d", model.PageFilter.PageIndex, model.OrderList.count);
                                                     [hud hide:YES afterDelay:0];
                                                     
                                                 } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                     NSLog(@"failure %@", errorMsg);
                                                     hud.labelText = errorMsg;
                                                     [hud hide:YES afterDelay:1.5];
                                                 }];
    } else {
        [WENetUtil GetMyOrderListToCommentWithPageIndex:_curPage
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
                                                    
                                                    NSMutableArray *total = _orderListArray;
                                                    if ([total count] == _curPage-1 && _curPage == model.PageFilter.PageIndex) {
                                                        [total addObject:model];
                                                        _curPage++;
                                                    } else {
                                                        NSLog(@"something error, %d, %d, %d", [total count], _curPage, model.PageFilter.PageIndex);
                                                    }
                                                    
                                                    [_tableView reloadData];
                                                    [self updateAllLoadedState];
                                                    NSLog(@"GetMyOrderListToCommentWithPageIndex, page %d, items count %d", model.PageFilter.PageIndex, model.OrderList.count);
                                                    [hud hide:YES afterDelay:0];
                                                    
                                                } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                    NSLog(@"failure %@", errorMsg);
                                                    hud.labelText = errorMsg;
                                                    [hud hide:YES afterDelay:1.5];
                                                }];
    }
    
}

- (void)reloadAllData
{
    _curPage = 1;
    [_orderListArray removeAllObjects];
    [self updateAllLoadedState];
    [self realLoadData];
}

- (void)loadMoreData
{
    [self realLoadData];
}

- (NSNumber *)isAllLoaded
{
    NSMutableArray *total = _orderListArray;
    if(total.count) {
        WEModelGetMyOrderList *model = [total lastObject];
        if (model.PageFilter.PageIndex >= model.PageFilter.TotalPages)
            return @YES;
    }
    return @NO;
}

- (BOOL)loadDataIfNeeded
{
    NSMutableArray *total = _orderListArray;
    if(total.count) {
        [_tableView reloadData];
        return YES;
    } else {
        [_tableView.mj_header beginRefreshing];
        return NO;
    }
}

- (void)downPull
{
    [self reloadAllData];
    [_tableView.mj_header endRefreshing];
}

- (void)upPull
{
    if ([[self upPullFinished] boolValue]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadMoreData];
        [_tableView.mj_footer endRefreshing];
    }
    
}

- (NSNumber *)upPullFinished
{
    return [self isAllLoaded];
}

- (void)updateAllLoadedState
{
    if (![[self upPullFinished] boolValue]) {
        [_tableView.mj_footer resetNoMoreData];
    } else {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (id)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelGetMyOrderList *model in _orderListArray) {
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
    for(WEModelGetMyOrderList *model in _orderListArray) {
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
    if (_isOngoingState) {
        cell.type = WEMainOrderViewCellType_ON_GOING;
    } else  {
        cell.type = WEMainOrderViewCellType_WAIT_COMMENT;
    }
    id model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index;
    if (_isOngoingState) {
        index = 0;
    } else {
        index = 1;
    }
    return [WEMainOrderViewCell getHeightWithType:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
