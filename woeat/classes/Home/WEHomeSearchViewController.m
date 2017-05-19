//
//  WEHomeSearchViewController.m
//  woeat
//
//  Created by liubin on 17/1/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEHomeSearchViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "WEHomeSearchCell.h"
#import "WEModelWildSearch.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "WEHomeKitchenViewController.h"
#import "WEHomeKitchenDishViewController.h"
#import "UmengStat.h"

@interface WEHomeSearchViewController ()
{
    UITextField *_searchField;
    UITableView *_tableView;
    NSMutableArray *_wildSearchArray; //array of WEModelWildSearch
    int _curPage;//from 1
}
@end

@implementation WEHomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    

    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"搜索";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=UICOLOR(100, 100, 100).CGColor;
    textField.layer.borderWidth= 1.0f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    textField.leftView = view1;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"厨房名称或菜品名称" attributes:@{NSForegroundColorAttributeName: UICOLOR(150, 150, 150),
                                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:12] ,}];
    [superView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.width.equalTo([WEUtil getScreenWidth]*0.6);
        make.height.equalTo(30);
        make.top.equalTo(self.mas_topLayoutGuide).offset(15);
    }];
    _searchField = textField;

    UIButton *button = [UIButton new];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = DARK_ORANGE_COLOR;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    button.layer.cornerRadius=4.0f;
    button.layer.masksToBounds=YES;
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchField.right).offset(15);
        make.width.equalTo([WEUtil getScreenWidth]*0.15);
        make.height.equalTo(_searchField.height);
        make.centerY.equalTo(_searchField.centerY);
    }];
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[WEHomeSearchCell class] forCellReuseIdentifier:@"WEHomeSearchCell"];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchField.bottom).offset(20);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    //_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UmengStat pageEnter:UMENG_STAT_PAGE_SEARCH];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_SEARCH];
}

- (void)initData
{
    _curPage = 1;
    _wildSearchArray = [NSMutableArray new];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row = 0;
    for(WEModelWildSearch *model in _wildSearchArray) {
        row += model.KitchenList.count;
    }
    return row;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WEHomeSearchCell";
    WEHomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WEHomeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    if (indexPath.row == 0) {
        cell.isFirstCell = YES;
    } else {
        cell.isFirstCell = NO;
    }
    WEModelWildSearchKitchenList *model = [self getModelAtIndexPath:indexPath];
    [cell setData:model];
    cell.dishDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEModelWildSearchKitchenList *model = [self getModelAtIndexPath:indexPath];
    return [WEHomeSearchCell getHeightWithData:model];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEModelWildSearchKitchenList *model = [self getModelAtIndexPath:indexPath];
    NSString *kitchenId = model.KitchenId;
    WEHomeKitchenViewController *c = [WEHomeKitchenViewController new];
    c.kitchenId = kitchenId;
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:c animated:YES];
}


- (void)realLoadData
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在搜索，请稍后...";
    [hud show:YES];
    [WENetUtil WildSearchWithKeywords:_searchField.text
                            PageIndex:_curPage
                            Longitude:TEST_Longitude
                             Latitude:TEST_Latitude
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  JSONModelError* error = nil;
                                  NSDictionary *dict = (NSDictionary *)responseObject;
                                  WEModelWildSearch *model = [[WEModelWildSearch alloc] initWithDictionary:dict error:&error];
                                  if (error) {
                                      NSLog(@"error %@", error);
                                  }
                                  if (model.IsSuccessful) {
                                      [hud hide:YES afterDelay:0];
                                      NSMutableArray *total = _wildSearchArray;
                                      if ([total count] == _curPage-1 && _curPage == model.PageNumber) {
                                          [total addObject:model];
                                          _curPage++;
                                      } else {
                                          NSLog(@"something error, %d, %d, %d", [total count], _curPage, model.PageNumber);
                                      }
                                      [self updateAllLoadedState];
                                      NSLog(@"WildSearch, page %d, items count %d, at index %d", model.PageCount, model.KitchenList.count, index);
                                      [_tableView reloadData];
                                      
                                  } else {
                                      hud.labelText = model.ResponseMessage;
                                      [hud hide:YES afterDelay:1.5];
                                  }
                                  
                              } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                  hud.labelText = errorMsg;
                                  [hud hide:YES afterDelay:1.5];
                              }];
    
}

- (void)reloadAllData
{
    _curPage = 1;
    [_wildSearchArray removeAllObjects];
    [self updateAllLoadedState];
    [self realLoadData];
}

- (void)loadMoreData
{
    [self realLoadData];
}

- (NSNumber *)isAllLoaded
{
    NSMutableArray *total = _wildSearchArray;
    if(total.count) {
        WEModelWildSearch *model = [total lastObject];
        if (model.PageNumber >= model.PageCount)
            return @YES;
    }
    return @NO;
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

- (WEModelWildSearchKitchenList *)getModelAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    for(WEModelWildSearch *model in _wildSearchArray) {
        row -= model.KitchenList.count;
        if (row < 0) {
            return model.KitchenList[row + model.KitchenList.count];
        }
    }
    return nil;
}

- (void)searchButtonTapped:(UIButton *)button
{
    if (!_searchField.text.length) {
        return;
    }
    
    [_searchField resignFirstResponder];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];
    [self reloadAllData];
}

- (void)searchDishTapped:(NSString *)itemId kitchen:(NSString *)kitchenId
{
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    WEHomeKitchenViewController *kitchenViewController = [WEHomeKitchenViewController new];
    kitchenViewController.kitchenId = kitchenId;
    [nav pushViewController:kitchenViewController animated:NO];
    
    WEHomeKitchenDishViewController *c = [WEHomeKitchenDishViewController new];
    c.itemId = itemId;
    c.kitchenId = kitchenId;
    //    c.modelItemToday = _modelItemToday;
    //    c.modelItemTomorrow = _modelItemTomorrow;
    //c.modelGetConsumerKitchen = _modelGetConsumerKitchen;
    [nav pushViewController:c animated:YES];
    
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
