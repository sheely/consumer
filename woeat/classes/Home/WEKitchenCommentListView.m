//
//  WEKitchenCommentListView.m
//  woeat
//
//  Created by liubin on 17/1/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEKitchenCommentListView.h"
#import "WEUtil.h"
#import "UIImageView+WebCache.h"
#import "WEModelGetCommentList.h"
#import "WEHomeKitchenViewComentCell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "WENetUtil.h"

#define PAGE_COUNT 10

@interface WEKitchenCommentListView()
{

    UILabel *_commentNumberLabel;
    MASConstraint *_commentTableViewHeightConstraint;
    NSMutableArray *_commentListhArray; //array of WEModelGetCommentList
    int _curPage;//from 1
}

@end


@implementation WEKitchenCommentListView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        UIView *superView = self;
        
        float offsetX = 15;
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = UICOLOR(184, 184, 184);
        [superView addSubview:bottomLine];
        [bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top);
            make.height.equalTo(1);
        }];
        
        UILabel *bottomHeader = [UILabel new];
        bottomHeader.textColor = [UIColor blackColor];
        bottomHeader.font = [UIFont systemFontOfSize:14];
        [superView addSubview:bottomHeader];
        [bottomHeader sizeToFit];
        [bottomHeader makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.top.equalTo(bottomLine.bottom).offset(5);
        }];
        bottomHeader.text = @"饭友评论";
        
        UILabel *bottomNumber = [UILabel new];
        bottomNumber.textColor = [UIColor grayColor];
        bottomNumber.font = [UIFont systemFontOfSize:14];
        [superView addSubview:bottomNumber];
        [bottomNumber sizeToFit];
        [bottomNumber makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomHeader.right).offset(10);
            make.centerY.equalTo(bottomHeader.centerY);
        }];
        //bottomNumber.text = @"69条";
        _commentNumberLabel = bottomNumber;
        
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[WEHomeKitchenViewComentCell class] forCellReuseIdentifier:@"WEHomeKitchenViewComentCell"];
        [superView addSubview:tableView];
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomHeader.bottom).offset(10);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            _commentTableViewHeightConstraint = make.height.equalTo(0);
            make.bottom.equalTo(superView.bottom);
        }];
        _tableView = tableView;
    }
    return self;
    
}

- (void)initData
{
    _curPage = 1;
    _commentListhArray = [NSMutableArray new];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row = 0;
    for(WEModelGetCommentList *model in _commentListhArray) {
        row += model.CommentList.count;
    }
    return row;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEHomeKitchenViewComentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEHomeKitchenViewComentCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [WEHomeKitchenViewComentCell new];
    }
    WEModelGetCommentListCommentList *model = [self getModelAtIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEModelGetCommentListCommentList *model = [self getModelAtIndexPath:indexPath];
    return [WEHomeKitchenViewComentCell getHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)updateUI
{
    if (_commentListhArray.count == 0)
        return;
    
    WEModelGetCommentList *model = [_commentListhArray objectAtIndex:0];
    _commentNumberLabel.text = [NSString stringWithFormat:@"%d条", model.PageFilter.TotalRecords];
    [_tableView reloadData];
     _commentTableViewHeightConstraint.equalTo( _tableView.contentSize.height );
}

//- (void)realLoadData
//{
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
//    if (!hud) {
//        hud = [[MBProgressHUD alloc] initWithView:self];
//        //hud.yOffset = -30;
//        [self addSubview:hud];
//    }
//    hud.labelText = @"正在获取评论，请稍后...";
//    [hud show:YES];
//    [WENetUtil GetCommentListOpenWithPageIndex:_curPage
//                                      Pagesize:10
//                                     kitchenId:_kitchenId
//                                       success:^(NSURLSessionDataTask *task, id responseObject) {
//                                           JSONModelError* error = nil;
//                                           NSDictionary *dict = (NSDictionary *)responseObject;
//                                           WEModelGetCommentList *model = [[WEModelGetCommentList alloc] initWithDictionary:dict error:&error];
//                                           if (error) {
//                                               NSLog(@"error %@", error);
//                                           }
//                                           if (!model.IsSuccessful) {
//                                               hud.labelText = model.ResponseMessage;
//                                               [hud hide:YES afterDelay:1.5];
//                                               return;
//                                           }
//                                           [hud hide:YES afterDelay:0];
//                                           NSMutableArray *total = _commentListhArray;
//                                           if ([total count] == _curPage-1 && _curPage == model.PageFilter.PageIndex) {
//                                               [total addObject:model];
//                                               _curPage++;
//                                           } else {
//                                               NSLog(@"something error, %d, %d, %d", [total count], _curPage, model.PageFilter.PageIndex);
//                                               if ([total count] >= _curPage-1) {
//                                                   total[_curPage-1] = model;
//                                               }
//                                           }
//                                           [self updateAllLoadedState];
//                                           NSLog(@"GetCommentListOpenWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
//                                           [self updateUI];
//                                           
//                                       } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
//                                           NSLog(@"errorMsg %@", errorMsg);
//                                           hud.labelText = errorMsg;
//                                           [hud hide:YES afterDelay:1.5];
//                                       }];
//
//}
- (void)realLoadData
{
    [WENetUtil GetCommentListOpenWithPageIndex:_curPage
                                      Pagesize:PAGE_COUNT
                                     kitchenId:_kitchenId
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           JSONModelError* error = nil;
                                           NSDictionary *dict = (NSDictionary *)responseObject;
                                           WEModelGetCommentList *model = [[WEModelGetCommentList alloc] initWithDictionary:dict error:&error];
                                           if (error) {
                                               NSLog(@"error %@", error);
                                           }
                                           if (!model.IsSuccessful) {
                                               return;
                                           }
                                           NSMutableArray *total = _commentListhArray;
                                           if ([total count] == _curPage-1 && _curPage == model.PageFilter.PageIndex) {
                                               [total addObject:model];
                                               _curPage++;
                                           } else {
                                               NSLog(@"something error, %d, %d, %d", [total count], _curPage, model.PageFilter.PageIndex);
                                           }
                                           [self updateAllLoadedState];
                                           NSLog(@"GetCommentListOpenWithPageIndex, page %d, items count %d, at index %d", model.PageFilter.PageIndex, model.CommentList.count, index);
                                           [self updateUI];
                                           
                                       } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                           NSLog(@"errorMsg %@", errorMsg);
                                       }];
    
}

- (void)reloadAllData
{
    _curPage = 1;
    [_commentListhArray removeAllObjects];
    [self updateAllLoadedState];
    [self realLoadData];
}

- (void)loadMoreData
{
    [self realLoadData];
}

- (NSNumber *)isAllLoaded
{
    NSMutableArray *total = _commentListhArray;
    if(total.count) {
        WEModelGetCommentList *model = [total lastObject];
        if (model.PageFilter.PageIndex >= model.PageFilter.TotalPages)
            return @YES;
    }
    return @NO;
}

- (BOOL)loadDataIfNeeded
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    //_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];
    _parentScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];

    NSMutableArray *total = _commentListhArray;
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
        [_parentScrollView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadMoreData];
        [_parentScrollView.mj_footer endRefreshing];
    }
}

- (NSNumber *)upPullFinished
{
    return [self isAllLoaded];
}

- (void)updateAllLoadedState
{
    if (![[self upPullFinished] boolValue]) {
        [_parentScrollView.mj_footer resetNoMoreData];
    } else {
        [_parentScrollView.mj_footer endRefreshingWithNoMoreData];
    }
}


- (WEModelGetCommentListCommentList *)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelGetCommentList *model in _commentListhArray) {
        row -= model.CommentList.count;
        if (row < 0) {
            return model.CommentList[row + model.CommentList.count];
        }
    }
    return nil;
}
@end
