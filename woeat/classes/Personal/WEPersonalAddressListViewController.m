//
//  WEPersonalAddressListViewController.m
//  woeat
//
//  Created by liubin on 16/11/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPersonalAddressListViewController.h"
#import "WEPersonalAddressListCellTableViewCell.h"
#import "WEPersonalAddressEditViewController.h"
#import "WEAddressManager.h"
#import "WEAddress.h"
#import "WENetUtil.h"
#import "WEModelGetMyDeliveryAddressList.h"
#import "MBProgressHUD.h"
#import "UmengStat.h"

@interface WEPersonalAddressListViewController ()
{
    UITableView *_tableView;
    UILabel *_emptyLabel;
}
@end

@implementation WEPersonalAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的送餐地址";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    [tableView registerClass:[WEPersonalAddressListCellTableViewCell class] forCellReuseIdentifier:@"WEPersonalAddressListCellTableViewCell"];
    tableView.showsVerticalScrollIndicator = YES;
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    
    UILabel *empty = [UILabel new];
    empty.text = @"无送餐地址，请点击右上角按钮添加";
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
    [self addRightNavButton:@"添加地址" image:nil target:self selector:@selector(rightButtonTapped:)];
    [[WEAddressManager sharedInstance] loadAllWithDelegate:self];
    [UmengStat pageEnter:UMENG_STAT_PAGE_ADDRESS_LIST];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_ADDRESS_LIST];
}


- (void)loadStart
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取地址，请稍后...";
    [hud show:YES];
    
}
- (void)loadFinished
{
    [_tableView reloadData];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (hud) {
        [hud hide:YES afterDelay:0.5];
    }
}



- (void)rightButtonTapped:(UIButton *)button
{
    WEPersonalAddressEditViewController *c = [WEPersonalAddressEditViewController new];
    c.parentController = self;
//    WEAddress *a = [WEAddress new];
//    WEAddressManager *manager = [WEAddressManager sharedInstance];
//    NSMutableArray *array = [manager loadAddress];
//    c.address = a;
//    [array addObject:a];
    [self.navigationController pushViewController:c animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WEAddressManager *manager = [WEAddressManager sharedInstance];
    NSArray *array = [manager allAddress];
    int count =  array.count;
    if (count) {
        _emptyLabel.hidden = YES;
    } else {
        _emptyLabel.hidden = NO;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WEPersonalAddressListCellTableViewCell";
    WEPersonalAddressListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WEPersonalAddressListCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    WEAddressManager *manager = [WEAddressManager sharedInstance];
    NSArray *array = [manager allAddress];
    WEAddress *address = array[indexPath.row];
    [cell setModel:address];
    if (_fromOrderConfirm) {
        if (indexPath.row == manager.getSelectedIndex) {
            [cell setIsSelected:YES];
        } else {
            [cell setIsSelected:NO];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fromOrderConfirm) {
        [[WEAddressManager sharedInstance] setSelectedIndex:indexPath.row];
        [_tableView reloadData];
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            //hud.yOffset = -30;
            [self.view addSubview:hud];
        }
        hud.labelText = @"地址设置成功";
        [hud show:YES];
        [hud hide:YES afterDelay:1];
        hud.delegate = self;
        
    } else {
        WEPersonalAddressEditViewController *c = [WEPersonalAddressEditViewController new];
        c.parentController = self;
        WEAddressManager *manager = [WEAddressManager sharedInstance];
        NSArray *array = [manager allAddress];
        WEAddress *address = array[indexPath.row];
        c.address = address;
        [self.navigationController pushViewController:c animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WEAddressManager *manager = [WEAddressManager sharedInstance];
        NSArray *array = [manager allAddress];
        WEAddress *address = array[indexPath.row];
        int select = [manager getSelectedIndex];
        if (select == indexPath.row) {
            [manager setSelectedIndex:0];
        } else if (select > indexPath.row) {
            [manager setSelectedIndex:select-1];
        }
        

        [[WEAddressManager sharedInstance] deleteAddress:address withDelegate:self];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            //hud.yOffset = -30;
            [self.view addSubview:hud];
        }
        hud.labelText = @"正在删除地址，请稍后...";
        [hud show:YES];

    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除地址";
}

- (void)deleteFinished
{
    //[_tableView reloadData];
}

- (void)addFinished
{
     //[_tableView reloadData];
}

@end
