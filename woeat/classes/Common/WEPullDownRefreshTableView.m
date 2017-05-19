//
//  WEPullDownRefreshTableView.m
//  woeat
//
//  Created by liubin on 16/11/4.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPullDownRefreshTableView.h"
#import "MJRefresh.h"

@interface WEPullDownRefreshTableView()

@property(nonatomic, weak) id refreshTarget;
@property(nonatomic, assign) SEL headerRefreshSel;
@property(nonatomic, assign) SEL footerRefreshSel;
@property(nonatomic, assign) SEL isAllLoadedSel;
@end

@implementation WEPullDownRefreshTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    return self;
}

- (void)pullDownSetRefreshTarget:(id)target headerSel:(SEL)headerSel footerSel:(SEL)footerSel isAllLoadedSel:(SEL)isAllLoadedSel
{
    self.refreshTarget = target;
    self.headerRefreshSel = headerSel;
    self.footerRefreshSel = footerSel;
    self.isAllLoadedSel = isAllLoadedSel;
    if (headerSel) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownHeaderRefreshAction)];
    } else {
        self.header = nil;
    }
    if (footerSel) {
        self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullDownFooterRefreshAction)];
    } else {
        self.footer = nil;
    }
}

- (void)pullDownHeaderRefreshAction
{
    [self.refreshTarget performSelector:self.headerRefreshSel withObject:nil];
    [self.header endRefreshing];
}

- (void)pullDownFooterRefreshAction
{
    if ([[self.refreshTarget performSelector:self.isAllLoadedSel withObject:nil] boolValue]) {
        [self.footer endRefreshingWithNoMoreData];
    } else {
        [self.refreshTarget performSelector:self.footerRefreshSel withObject:nil];
        [self.footer endRefreshing];
    }
}

- (void)clearAllLoadedState
{
    [self.footer resetNoMoreData];
}

- (void)setAllLoadedState
{
    [self.footer endRefreshingWithNoMoreData];
}

- (void)pullDownHeaderBeginRefresh
{
    [self.header beginRefreshing];
}


@end
