//
//  WEPersonalCenterViewController.m
//  woeat
//
//  Created by liubin on 16/11/26.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPersonalCenterViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "UIImageView+WebCache.h"
#import "WETwoLineListWideView.h"
#import "WEPersonalSettingViewController.h"
#import "WEConstants.h"
#import "WEPersonalCommentViewController.h"
#import "WEPersonalAddressListViewController.h"
#import "WECouponListViewController.h"
#import "WEMainTabBarController.h"
#import "AppDelegate.h"
#import "WESingleStateOrderViewController.h"
#import "WEPersonalCenterViewController.h"
#import "WEProfileImage.h"
#import "WEUserDataManager.h"
#import "WEGlobalData.h"
#import "WEToken.h"
#import "WESingleWebViewController.h"
#import "WERegisterKitchenViewController.h"
#import "WEAddressManager.h"
#import "UmengStat.h"
#import "WEBankCardListViewController.h"

typedef enum PERSONAL_ROW
{
    PERSONAL_ROW_MY_ORDER = 0,
    PERSONAL_ROW_MY_ORDER_ONGOING,
    PERSONAL_ROW_MY_ORDER_WAIT_COMMENT,
    PERSONAL_ROW_MY_ORDER_FINISHED,
    PERSONAL_ROW_MY_COUPON,
    PERSONAL_ROW_MY_COMMENT,
    PERSONAL_ROW_ADDRESS,
    PERSONAL_ROW_BANK_CARD,
    PERSONAL_ROW_APPLY,
    PERSONAL_ROW_DECLARATION,
    PERSONAL_ROW_ABOUT,
    PERSONAL_ROW_QUIT,
    PERSONAL_ROW_MAX
}PERSONAL_ROW;

#define BUTTON_TAG_START  100

@interface WEPersonalCenterViewController ()
{
    UIScrollView *_scrollView;
    
    UITableView *_personalTableView;
    MASConstraint *_personalTableViewHeightConstraint;
    
    UIImageView *_personView;
    UILabel *_personName;
    //WETwoLineListWideView *_twoLineList;
    
    UILabel *_balanceLabel;
}
@end

@implementation WEPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    //scroll
    UIScrollView *scrollView = [UIScrollView new];
    [superView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _scrollView = scrollView;
    
    //content
    superView = scrollView;
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [superView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.top);
        make.left.equalTo(scrollView.left);
        make.right.equalTo(scrollView.right);
        make.bottom.equalTo(scrollView.bottom);
        make.width.equalTo([WEUtil getScreenWidth]);
    }];
    
    superView = contentView;
    
    UIImageView *personView = [UIImageView new];
    personView.backgroundColor = [UIColor lightGrayColor];
    float radius = COND_WIDTH_320(70, 60);
    personView.layer.cornerRadius = radius;
    personView.layer.masksToBounds = YES;
    [superView addSubview:personView];
    [personView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(superView.top).offset(20);
        make.width.equalTo(radius*2);
        make.height.equalTo(radius*2);
    }];
    _personView = personView;
    _personView.image = [WEProfileImage loadProfileImage];
    
    UILabel *personName = [UILabel new];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = UICOLOR(0, 0, 0);
    personName.font = [UIFont systemFontOfSize:14];
    personName.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:personName];
    [personName makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(personView.centerX);
        make.top.equalTo(personView.bottom).offset(15);
        make.width.equalTo([WEUtil getScreenWidth]);
        make.height.equalTo(personName.font.pointSize+1);
    }];
    personName.text = [[WEUserDataManager sharedInstance] getNick];
    _personName = personName;
    
    UILabel *balanceLabel = [UILabel new];
    balanceLabel.backgroundColor = DARK_ORANGE_COLOR;
    balanceLabel.textColor = [UIColor whiteColor];
    balanceLabel.font = [UIFont systemFontOfSize:14];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:balanceLabel];
    [balanceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(personName.bottom).offset(15);
        make.height.equalTo(50);
    }];
    NSNumber* balance = [[WEUserDataManager sharedInstance] getBalance];
    NSString *balanceString = @"";
    if (balance) {
        balanceString = [NSString stringWithFormat:@"$ %.2f", balance.doubleValue];
    } else {
        balanceString = @"       ";
    }
    balanceLabel.text = [NSString stringWithFormat:@"余额    %@", balanceString];
    _balanceLabel = balanceLabel;
    
//    WETwoLineListWideView *twoLineList = [WETwoLineListWideView new];
//    twoLineList.backgroundColor = DARK_ORANGE_COLOR;
//    twoLineList.upFont = [UIFont systemFontOfSize:17];
//    twoLineList.downFont = [UIFont boldSystemFontOfSize:15];
//    twoLineList.upColor = [UIColor whiteColor];
//    twoLineList.downColor = [UIColor whiteColor];
//    twoLineList.leftPadding = 0;
//    twoLineList.rightPadding = 0;
//    twoLineList.topPadding = 30;
//    twoLineList.bottomPadding = 25;
//    twoLineList.middleYPadding = 15;
//    twoLineList.lineColor = [UIColor whiteColor];
//    twoLineList.lineWidth = 2;
//    twoLineList.lineHeight = 40;
//    twoLineList.totalWidth = [WEUtil getScreenWidth];
//    [superView addSubview:twoLineList];
//    NSNumber* balance = [[WEUserDataManager sharedInstance] getBalance];
//    NSString *balanceString = @"";
//    if (balance) {
//        balanceString = [NSString stringWithFormat:@"$ %.2f", balance.doubleValue];
//    } else {
//        balanceString = @"       ";
//    }
//    NSArray *ups = @[balanceString];
//    NSArray *downs = @[@"余额"];
//    [twoLineList setUpText:ups downText:downs];
//    [twoLineList makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left);
//        make.top.equalTo(personName.bottom).offset(20);
//        make.right.equalTo(superView.right);
//        make.height.equalTo([twoLineList getHeight]);
//    }];
//    for(int i=0; i<twoLineList.buttons.count; i++) {
//        UIButton *button = twoLineList.buttons[i];
//        button.tag = BUTTON_TAG_START + i;
//        [button addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    _twoLineList = twoLineList;
    
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLabel.bottom);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _personalTableViewHeightConstraint = make.height.equalTo(400);
         make.bottom.equalTo(superView.bottom);
    }];
    _personalTableView = tableView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileImageLoad:) name:NOTIFICATION_PROFILE_IMAGE_RELOAD object:nil];
    [self loadUserData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addRightNavButton:@"设置" image:nil target:self selector:@selector(rightButtonTapped:)];
    [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
    [self updateUI];
    [UmengStat pageEnter:UMENG_STAT_PAGE_PERCENTER_CENTER];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTableHeight];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_PERCENTER_CENTER];
}

- (void)updateUI
{
    _personName.text = [[WEUserDataManager sharedInstance] getNick];
    _personView.image = [WEProfileImage loadProfileImage];
    
    NSNumber* balance = [[WEUserDataManager sharedInstance] getBalance];
    NSString *balanceString = @"";
    if (balance) {
        balanceString = [NSString stringWithFormat:@"$ %.2f", balance.doubleValue];
    }
    _balanceLabel.text = [NSString stringWithFormat:@"余额    %@", balanceString];
//    NSArray *ups = @[balanceString];
//    NSArray *downs = @[@"余额"];
//    [_twoLineList setUpText:ups downText:downs];
//    [_twoLineList updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo([_twoLineList getHeight]);
//    }];
//    for(int i=0; i<_twoLineList.buttons.count; i++) {
//        UIButton *button = _twoLineList.buttons[i];
//        button.tag = BUTTON_TAG_START + i;
//        [button addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    }
}

- (void)loadUserData
{
    [WENetUtil GetMyDetailsSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        dict = [dict objectForKey:@"User"];
        NSString *nick = [dict objectForKey:@"DisplayName"];
        NSString *gender = [dict objectForKey:@"Gender"];
        NSNumber *balance = [dict objectForKey:@"TotalBalance"];
        NSString *imageUrl = [dict objectForKey:@"PortraitImageUrl"];
        if (nick.length) {
            [[WEUserDataManager sharedInstance] setNick:nick];
        }
        if (gender.length) {
            if ([gender isEqualToString:@"M"]) {
                [[WEUserDataManager sharedInstance] setMale:YES];
            } else {
                [[WEUserDataManager sharedInstance] setMale:NO];
            }
        }
        if (balance) {
            [[WEUserDataManager sharedInstance] setBalance:balance];
        }
        if (imageUrl.length) {
            [WEProfileImage downloadImage:imageUrl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"GetMyDetails fail %@", errorMsg);
    }];
}



- (void)rightButtonTapped:(UIButton *)button
{
    WEPersonalSettingViewController *c = [WEPersonalSettingViewController new];
    [self.navigationController pushViewController:c animated:YES];
}


- (void)updateTableHeight
{
    _personalTableViewHeightConstraint.equalTo(_personalTableView.contentSize.height);
    
}

- (void)applyButtonClicked:(UIButton *)button
{
    WERegisterKitchenViewController *vc = [WERegisterKitchenViewController new];
    NSArray *array = [[WEAddressManager sharedInstance] allAddress];
    if (array.count) {
        int index = [[WEAddressManager sharedInstance] getSelectedIndex];
        if (index < array.count) {
            WEAddress *a = [array objectAtIndex:index];
            vc.address = a;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return PERSONAL_ROW_MAX;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    
    NSString *titles[] = {@"我的订单", @"进行中", @"待评价", @"已完成", @"优惠券", @"我的评论", @"送餐地址",
        @"我的银行卡", @"申请成为家厨", @"免责声明", @"关于WOEAT", @"退出登录"};
    float offsetX = 25;
    if (indexPath.row == PERSONAL_ROW_MY_ORDER) {
        UILabel *name = [UILabel new];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = UICOLOR(0, 0, 0);
        name.font = [UIFont systemFontOfSize:14];
        name.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:name];
        [name sizeToFit];
        [name makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        name.text = titles[indexPath.row];
    
    } else if (indexPath.row >= PERSONAL_ROW_MY_ORDER_ONGOING && indexPath.row <= PERSONAL_ROW_MY_ORDER_FINISHED) {
        UILabel *name = [UILabel new];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = UICOLOR(120, 120, 120);
        name.font = [UIFont systemFontOfSize:14];
        name.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:name];
        [name sizeToFit];
        [name makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX+10);
            make.centerY.equalTo(superView.centerY);
        }];
        name.text = titles[indexPath.row];
        
        UIImageView *arrow = [UIImageView new];
        arrow.image = [UIImage imageNamed:@"icon_arrow_gray"];
        [superView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-offsetX);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(arrow.image.size.width);
            make.height.equalTo(arrow.image.size.height);
        }];
    
    } else if (indexPath.row == PERSONAL_ROW_APPLY) {
        UIButton *button = [UIButton new];
        [button setTitle:titles[indexPath.row] forState:UIControlStateNormal];
        [button setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(applyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = DARK_ORANGE_COLOR;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.layer.cornerRadius=8.0f;
        button.layer.masksToBounds=YES;
        [superView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top).offset(10);
            make.bottom.equalTo(superView.bottom).offset(-10);
        }];
    
    } else if (indexPath.row == PERSONAL_ROW_QUIT) {
        UIButton *button = [UIButton new];
        [button setTitle:titles[indexPath.row] forState:UIControlStateNormal];
        [button setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(quitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = DARK_ORANGE_COLOR;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.layer.cornerRadius=8.0f;
        button.layer.masksToBounds=YES;
        [superView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top).offset(10);
            make.bottom.equalTo(superView.bottom).offset(-10);
        }];
        
    } else {
        UILabel *name = [UILabel new];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = UICOLOR(0, 0, 0);
        name.font = [UIFont systemFontOfSize:14];
        name.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:name];
        [name sizeToFit];
        [name makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.centerY.equalTo(superView.centerY);
        }];
        name.text = titles[indexPath.row];
        
        UIImageView *arrow = [UIImageView new];
        arrow.image = [UIImage imageNamed:@"icon_arrow_gray"];
        [superView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-offsetX);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(arrow.image.size.width);
            make.height.equalTo(arrow.image.size.height);
        }];
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == PERSONAL_ROW_APPLY || indexPath.row == PERSONAL_ROW_QUIT) {
        return 60;
    } else {
        return 44;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == PERSONAL_ROW_MY_ORDER_ONGOING) {
        WESingleStateOrderViewController *c = [WESingleStateOrderViewController new];
        c.isOngoingState = YES;
        [self.navigationController pushViewController:c animated:YES];
    
    } else if (indexPath.row == PERSONAL_ROW_MY_ORDER_WAIT_COMMENT) {
        WESingleStateOrderViewController *c = [WESingleStateOrderViewController new];
        c.isOngoingState = NO;
        [self.navigationController pushViewController:c animated:YES];
        
    } else if (indexPath.row == PERSONAL_ROW_MY_ORDER_FINISHED) {
        WEPersonalCommentViewController *c = [WEPersonalCommentViewController new];
        [self.navigationController pushViewController:c animated:YES];
        
    } else if (indexPath.row == PERSONAL_ROW_MY_COUPON) {
        WECouponListViewController *c = [WECouponListViewController new];
        [self.navigationController pushViewController:c animated:YES];
        
    } else if (indexPath.row == PERSONAL_ROW_MY_COMMENT) {
        WEPersonalCommentViewController *c = [WEPersonalCommentViewController new];
        [self.navigationController pushViewController:c animated:YES];
   
    } else if (indexPath.row == PERSONAL_ROW_ADDRESS) {
        WEPersonalAddressListViewController *c = [WEPersonalAddressListViewController new];
        [self.navigationController pushViewController:c animated:YES];
        
    } else if (indexPath.row == PERSONAL_ROW_DECLARATION) {
        WESingleWebViewController *vc = [WESingleWebViewController new];
        vc.titleString = @"免责声明";
        vc.urlString = URL_USER_DECLARE;
        [self.navigationController pushViewController:vc animated:YES];
    
    } else if (indexPath.row == PERSONAL_ROW_ABOUT) {
        WESingleWebViewController *vc = [WESingleWebViewController new];
        vc.titleString = @"关于WOEAT";
        vc.urlString = URL_ABOUT;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == PERSONAL_ROW_BANK_CARD) {
        WEBankCardListViewController *vc = [WEBankCardListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)profileImageLoad:(NSNotification *)notif
{
    _personView.image = [WEProfileImage loadProfileImage];
}

- (void)topButtonTapped:(UIButton *)button
{
//    int index = button.tag - BUTTON_TAG_START;
//    NSLog(@"topButtonTapped index %d", index);
//    if (/*index == 0*/1) {
//        WECouponListViewController *c = [WECouponListViewController new];
//        [self.navigationController pushViewController:c animated:YES];
//    }
}

- (void)quitButtonClicked:(UIButton *)button
{
    [WEToken clearToken];
    [WEGlobalData logOut];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setRootToLoginController];
    [UmengStat signOut];
    
}

@end
