//
//  WEPersonalCommentViewController.m
//  woeat
//
//  Created by liubin on 16/11/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPersonalCommentViewController.h"
#import "WEUtil.h"
#import "UIImageView+WebCache.h"
#import "WEMainTabBarController.h"
#import "WEPersonalCommentCell.h"
#import "WENetUtil.h"
#import "WEModelGetCommentList.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "UmengStat.h"

#define PAGE_COUNT 10

@interface WEPersonalCommentViewController ()
{
    UITableView *_tableView;
    NSMutableArray *_getCommentListArray; //array of WEModelGetCommentList
    int _curPage;//from 1
}
@end

@implementation WEPersonalCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的评论";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WEPersonalCommentCell class] forCellReuseIdentifier:@"WEPersonalCommentCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataIfNeeded];
   // [self testReply];
    [UmengStat pageEnter:UMENG_STAT_PAGE_MY_COMMENT];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_MY_COMMENT];
}

- (void)initData
{
    _curPage = 1;
    _getCommentListArray = [NSMutableArray new];
}

- (void)realLoadData
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取数据，请稍后...";
    [hud show:YES];
    
    [WENetUtil GetCommentListWithPageIndex:_curPage
                                  Pagesize:PAGE_COUNT
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       JSONModelError* error = nil;
                                       NSDictionary *dict = (NSDictionary *)responseObject;
                                       WEModelGetCommentList *model = [[WEModelGetCommentList alloc] initWithDictionary:dict error:&error];
                                       if (error) {
                                           NSLog(@"error %@", error);
                                       }
//                                       NSArray *a = [dict objectForKey:@"CommentList"];
//                                       NSDictionary *b = [a objectAtIndex:0];
//                                       NSDictionary *c = [b objectForKey:@"Reply"];
//                                       WEModelGetCommentListCommentListReply *d = [[WEModelGetCommentListCommentListReply alloc] initWithDictionary:c error:&error];
                                       
                                       
                                       if (!model.IsSuccessful) {
                                           hud.labelText = model.ResponseMessage;
                                           [hud hide:YES afterDelay:1.5];
                                           return;
                                       }
                                       [hud hide:YES afterDelay:0];
                                       NSMutableArray *total = _getCommentListArray;
                                       if ([total count] == _curPage-1 && _curPage == model.PageFilter.PageIndex) {
                                           [total addObject:model];
                                           _curPage++;
                                       } else {
                                           NSLog(@"something error, %d, %d, %d", [total count], _curPage, model.PageFilter.PageIndex);
                                       }
                                       [self updateAllLoadedState];
                                       NSLog(@"GetCommentListWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                       [_tableView reloadData];
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                       NSLog(@"errorMsg %@", errorMsg);
                                       hud.labelText = errorMsg;
                                       [hud hide:YES afterDelay:1.5];
                                   }];
    
}

- (void)reloadAllData
{
    _curPage = 1;
    [_getCommentListArray removeAllObjects];
    [self updateAllLoadedState];
    [self realLoadData];
}

- (void)loadMoreData
{
    [self realLoadData];
}

- (NSNumber *)isAllLoaded
{
    NSMutableArray *total = _getCommentListArray;
    if(total.count) {
        WEModelGetCommentList *model = [total lastObject];
        if (model.PageFilter.PageIndex >= model.PageFilter.TotalPages)
            return @YES;
    }
    return @NO;
}

- (BOOL)loadDataIfNeeded
{
    NSMutableArray *total = _getCommentListArray;
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


- (void)testReply
{
    [WENetUtil ReplyCommentWithParentCommentId:@"10000025"
                                       Message:@"回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。\n回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。回复评论，感谢您的评论。"
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           
                                       }
                                       failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                           
                                       }];
}



- (WEModelGetCommentListCommentList *)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelGetCommentList *model in _getCommentListArray) {
        row -= model.CommentList.count;
        if (row < 0) {
            return model.CommentList[row + model.CommentList.count];
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row = 0;
    for(WEModelGetCommentList *model in _getCommentListArray) {
        row += model.CommentList.count;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WEPersonalCommentCell";
    WEPersonalCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WEPersonalCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    WEModelGetCommentListCommentList *model = [self getModelAtIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEModelGetCommentListCommentList *model = [self getModelAtIndexPath:indexPath];
    return [WEPersonalCommentCell getHeightWithModel:model];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
