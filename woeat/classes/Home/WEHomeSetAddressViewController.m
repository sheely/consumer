//
//  WEHomeSetAddressViewController.m
//  woeat
//
//  Created by liubin on 17/1/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEHomeSetAddressViewController.h"
#import "WEOpenCity.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "MBProgressHUD.h"
#import "WEState.h"
#import "WECity.h"
#import "UmengStat.h"

@interface WEHomeSetAddressViewController ()
{
    UITableView *_leftTable;
    UITableView *_rightTable;
    WEOpenCity *_openCity;
}
@end

@implementation WEHomeSetAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"设置当前地址";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    UILabel *tip = [UILabel new];
    tip.numberOfLines = 1;
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = [UIFont systemFontOfSize:13];
    tip.textColor = [UIColor grayColor];
    [superView addSubview:tip];
    [tip sizeToFit];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(15);
        make.top.equalTo(self.mas_topLayoutGuide).offset(25);
    }];
    tip.text = @"已开通服务地区";
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR(233,205,203);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right).offset(0);
        make.top.equalTo(tip.bottom).offset(10);
        make.height.equalTo(1);
    }];
    
    float tableHeight = 150;
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.width.equalTo([WEUtil getScreenWidth] * 0.4);
        make.height.equalTo(tableHeight);
    }];
    _leftTable = tableView;
    
    line = [UIView new];
    line.backgroundColor = UICOLOR(233,205,203);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTable.right).offset(0);
        make.width.equalTo(1);
        make.top.equalTo(_leftTable.top).offset(0);
        make.bottom.equalTo(_leftTable.bottom);
    }];
    
    tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.right).offset(0);
        make.right.equalTo(superView.right);
        make.top.equalTo(_leftTable.top).offset(0);
        make.bottom.equalTo(_leftTable.bottom);
    }];
    _rightTable = tableView;
    
    line = [UIView new];
    line.backgroundColor = UICOLOR(233,205,203);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(0);
        make.right.equalTo(superView.right).offset(0);
        make.top.equalTo(_rightTable.bottom).offset(0);
        make.height.equalTo(1);
    }];
    
    UIButton *button = [UIButton new];
    [button setTitle:@"自动选择我的当前地址" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UICOLOR(175,118,112) forState:UIControlStateNormal];
    button.titleLabel.font= [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(autoSelectAddress:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    [button sizeToFit];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip.left).offset(0);
        make.top.equalTo(_leftTable.bottom).offset(15);
    }];
    
    _openCity = [WEOpenCity sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UmengStat pageEnter:UMENG_STAT_PAGE_SET_ADDRESS];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_SET_ADDRESS];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftTable) {
        NSArray *array = [_openCity getStateArray];
        return array.count;
    } else {
        int stateId = [_openCity getSelectStateId];
        NSArray *array = [_openCity getCityArrayWithStateId:stateId];
        return array.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = nil;
    BOOL isSelect = NO;
    if (_leftTable == tableView) {
        NSArray *array = [_openCity getStateArray];
        int stateId = [_openCity getSelectStateId];
        WEState *state  = [array objectAtIndex:indexPath.row];
        title = state.Name;
        if (stateId == state.stateId) {
            isSelect = YES;
        }
    } else {
        int stateId = [_openCity getSelectStateId];
        int cityId = [_openCity getSelectCityId];
        NSArray *array = [_openCity getCityArrayWithStateId:stateId];
        WECity *city  = [array objectAtIndex:indexPath.row];
        title = city.Name;
        if (cityId == city.cityId) {
            isSelect = YES;
        }
    }
    
    UILabel *label = [UILabel new];
    if (isSelect) {
        label.backgroundColor = DARK_ORANGE_COLOR;
        label.textColor = [UIColor whiteColor];
    } else {
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UICOLOR(150,150,150);
    }
    label.text = [NSString stringWithFormat:@"   %@", title];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    UIView *superView = cell.contentView;
    [superView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom);
    }];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _rightTable) {
        int stateId = [_openCity getSelectStateId];
        NSArray *array = [_openCity getCityArrayWithStateId:stateId];
        WECity *city  = [array objectAtIndex:indexPath.row];
        [_openCity setSelectCityId:city.cityId];
        [tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_SELECT_CHANGE object:nil];
    }
}


- (void)autoSelectAddress:(UIButton *)button
{
    [_openCity setSelectCityId:0];
    [_rightTable reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_SELECT_CHANGE object:nil];
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
