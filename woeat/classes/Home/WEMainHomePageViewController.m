//
//  WEMainHomePageViewController.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEMainHomePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WEUtil.h"
#import "SDCycleScrollView.h"
#import "WMPageController.h"
#import "WEHomeKitchenListViewController.h"
#import "WEModelGetListForConsumerHome.h"
#import "WENetUtil.h"
#import "WEHomeKitchenDishViewController.h"
#import "WEModelGetList.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "WEIntroDownload.h"
#import "WEMainTabBarController.h"
#import "WEHomeSearchViewController.h"
#import "WEHomeSetAddressViewController.h"
#import "WELocationManager.h"
#import "WEOpenCity.h"
#import "UmengStat.h"
#import <Crashlytics/Crashlytics.h>


static NSString *sGetListMode[4] = {@"RECOMMEND", @"FAVOURITE", @"VISIT_HISTORY", @"NEW"};


@interface WEMainHomePageViewController ()
{
    //MASConstraint *contentHeightConstraint;
    UIScrollView *_scrollView;
    float _contentTopHeight;
    MASConstraint *_pageContentHeightConstraint;
    WMPageController *_pageController;
    
    SDCycleScrollView *_cycleScrollView;
    
    NSMutableArray *_kitchenListArray[4]; //array of WEModelGetList
    int _curPage[4];
    NSString *_sessionId[4];
    
    int _curModeIndex;
    WEHomeKitchenListViewController *_bottomControllers[4];
//    MJRefreshNormalHeader *_downPullHeader;
//    MJRefreshAutoNormalFooter *_upPullFooter;
    
    UILabel *_addressLabel;
    BOOL _selectLocationChanged;
}
@end

@implementation WEMainHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float headerHeigh = COND_HEIGHT_480(55, 50);
    UIView *headerBg = [[UIView alloc] initWithFrame:CGRectZero];
    [headerBg setBackgroundColor:UICOLOR(249,249,249)];
    [superView addSubview:headerBg];
    [headerBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(headerHeigh);
    }];
    
    superView = headerBg;
    UIImage *logoImg = [UIImage imageNamed:@"icon_logo_small"];
    UIButton *logo = [UIButton new];
    logo.adjustsImageWhenHighlighted = NO;
    [logo setBackgroundImage:logoImg forState:UIControlStateNormal];
    [superView addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(15);
        make.width.equalTo(logoImg.size.width);
        make.height.equalTo(logoImg.size.height);
        make.centerY.equalTo(superView.centerY);
    }];
    logo.hidden = YES;
    
    UIView *titleBg = [UILabel new];
    titleBg.backgroundColor = UICOLOR(235,235,235);
    titleBg.layer.cornerRadius=5;
    titleBg.layer.masksToBounds=YES;
    titleBg.layer.borderColor= UICOLOR(200,200,200).CGColor;
    titleBg.layer.borderWidth= 1;
    [superView addSubview:titleBg];
    [titleBg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.height.equalTo(superView.height).offset(-18);
        make.width.equalTo([WEUtil getScreenWidth]*0.5);
        make.centerY.equalTo(logo.centerY);
    }];
    
    UIImageView *locationImgView = [UIImageView new];
    locationImgView.image = [UIImage imageNamed:@"icon_location"];
    [superView addSubview:locationImgView];
    [locationImgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBg.left).offset(5);
        make.height.equalTo(locationImgView.image.size.height);
        make.width.equalTo(locationImgView.image.size.width);
        make.centerY.equalTo(titleBg.centerY);
    }];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:addressLabel];
    [addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImgView.right);
        make.height.equalTo(superView.height).offset(-18);
        make.right.equalTo(titleBg.right);
        make.centerY.equalTo(logo.centerY);
    }];
    _addressLabel = addressLabel;
    
    UIButton *addressButton = [UIButton new];
    addressButton.backgroundColor = [UIColor clearColor];
    [addressButton addTarget:self action:@selector(addressTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:addressButton];
    [addressButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBg.left);
        make.right.equalTo(titleBg.right);
        make.top.equalTo(titleBg.top);
        make.bottom.equalTo(titleBg.bottom);
    }];
    
    UIImage *searchImg = [UIImage imageNamed:@"icon_magnifier"];
    UIButton *search = [UIButton new];
    search.adjustsImageWhenHighlighted = NO;
    [search setBackgroundImage:searchImg forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:search];
    [search makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.centerY);
        make.right.equalTo(superView.right).offset(-15);
        make.width.equalTo(searchImg.size.width);
        make.height.equalTo(searchImg.size.height);
    }];

    UIView *line = [UIView new];
    line.backgroundColor = DARK_ORANGE_COLOR;
    [superView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(superView.bottom).offset(-1);
        make.height.equalTo(2);
    }];
    
    superView = self.view;
    //scroll
    UIScrollView *scrollView = [UIScrollView new];
    [superView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBg.bottom);
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
        make.top.equalTo(superView.top);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(scrollView.bottom);
        make.width.equalTo([WEUtil getScreenWidth]);
        //contentHeightConstraint = make.height.equalTo(1000);
    }];

    superView = contentView;
    float scrollPhotpHeigh = COND_HEIGHT_480(130, 130);
//    NSArray *imagesURLStrings = @[
//                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-01.jpg",
//                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-02.jpg",
//                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-03.jpg",
//                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-04.jpg",
//                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-05.jpg",
//                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-06.jpg",
//                                  ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [WEUtil getScreenWidth], scrollPhotpHeigh) delegate:self placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [superView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScrollTimeInterval = 4.0;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    //cycleScrollView.currentPageDotColor = [UIColor whiteColor];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//    });
    //cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    [cycleScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(scrollPhotpHeigh);
    }];
    _cycleScrollView = cycleScrollView;
    
    float middleSpace = 3;
    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:middleLine];
    [middleLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(cycleScrollView.bottom).offset(middleSpace);
        make.height.equalTo(1);
    }];

    
    NSArray *titles = @[@"推荐", @"收藏", @"常去", @"新厨房"];
    NSArray *classes = @[[WEHomeKitchenListViewController class], [WEHomeKitchenListViewController class], [WEHomeKitchenListViewController class], [WEHomeKitchenListViewController class]];
    WMPageController *pageController = [[WMPageController alloc] initWithViewControllerClasses:classes andTheirTitles:titles];
    //pageVC.menuItemWidth = 75;
    pageController.postNotification = YES;
    pageController.bounces = YES;
    pageController.menuHeight = 100;
    pageController.progressHeight = 10;
    pageController.progressViewBottomSpace = 10;
    pageController.itemTopSpace = 61;
    pageController.itemHeight = 18;
    pageController.progressWidth = 20;
    pageController.menuViewStyle = WMMenuViewStyleTriangle;
    pageController.titleSizeNormal = 14;
    pageController.titleSizeSelected = 15;
    pageController.dataSource = self;
    pageController.delegate = self;
    pageController.menuBGColor = UICOLOR(255,255,255);
    //CGFloat pageHeight = [WEUtil getScreenHeight] - 20 -headerHeigh - scrollPhotpHeigh - middleSpace - 49;
    
    float minHeight = pageController.menuHeight + pageController.menuViewBottomSpace;
    [pageController setViewFrame:CGRectMake(0, 0, [WEUtil getScreenWidth], minHeight)];
    
    [superView addSubview:pageController.view];
    [self addChildViewController:pageController];
    [pageController.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleLine.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(superView.bottom);
        _pageContentHeightConstraint = make.height.equalTo(minHeight);
    }];
    _pageController = pageController;
    
    //_contentTopHeight = scrollPhotpHeigh + middleSpace + pageController.menuHeight + pageController.menuViewBottomSpace;
    
    [self loadTopBanner];
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPull)];
    _scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPull)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSelectLocationChanged:) name:NOTIFICATION_LOCATION_SELECT_CHANGE object:nil];
    
    [self loadAddress];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favChanged:) name:NOTIFICATION_KITCHEN_FAV_CHANGE object:nil];
}

- (void)userSelectLocationChanged:(NSNotification *)notif
{
    _selectLocationChanged = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (_selectLocationChanged) {
        _selectLocationChanged = NO;
        [self downPull];
        [self loadAddress];
    } else {
        [self loadDataIfNeeded:0];
    }
    
    [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
    [UmengStat pageEnter:UMENG_STAT_PAGE_HOME];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkLocationState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_HOME];
}

- (void)checkLocationState
{
    int stateId = [[WEOpenCity sharedInstance] getSelectStateId];
    int cityId = [[WEOpenCity sharedInstance] getSelectCityId];
    if (stateId>0 && cityId>0) {
        return;
    }
    
    if (_addressLabel.text.length) {
        return;
    }
    
    WELocationManagerState state = [WELocationManager sharedInstance].state;
    NSLog(@"checkLocationState state=%d", state);
    if (state == WELocationManagerState_Init) {
        NSLog(@"should not init");
        return;
        
    } else if (state == WELocationManagerState_NO_AUTH) {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"无法获取您的位置"
                                                          message:[WELocationManager sharedInstance].errorDesc
                                                         delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        return;
    
    } else if (state == WELocationManagerState_UpdateFail) {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"无法获取您的位置"
                                                          message:[WELocationManager sharedInstance].errorDesc
                                                         delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        return;
        
    } else if (state == WELocationManagerState_Updating) {
        [self performSelector:@selector(checkLocationState) withObject:nil afterDelay:0.5];
        return;
    
    } else if (state == WELocationManagerState_UpdateSuccess) {
        [_scrollView.mj_header beginRefreshing];
        [self loadAddress];
    }
}


- (void)downloadIntrImage
{
    [WEIntroDownload downloadIntroImage];
}

- (void)initData
{
    for(int i=0; i<4; i++) {
        _curPage[i] = 1;
        _kitchenListArray[i] = [NSMutableArray new];
        _sessionId[i] = @"";
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
    hud.labelText = @"正在获取数据，请稍后...";
    [hud show:YES];
    
    [WENetUtil getListWithSessionId:_sessionId[index] PageNumber:_curPage[index] Mode:sGetListMode[index] Latitude:TEST_Latitude Longitude:TEST_Longitude success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud hide:YES afterDelay:0];
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetList *model = [[WEModelGetList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _sessionId[index] = model.SessionId;
        NSMutableArray *total = _kitchenListArray[index];
        if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageNumber) {
            [total addObject:model];
            _curPage[index]++;
        } else {
            NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageNumber);
        }
        _bottomControllers[index].dataArray = total;
        
        [_bottomControllers[index].tableView reloadData];
        [self updateBottomTableFrame];
        [self updateAllLoadedState];
        NSLog(@"get list data, page %d, items count %d, at index %d", model.PageNumber, model.Kitchens.count, index);
        
        [self performSelector:@selector(downloadIntrImage) withObject:nil afterDelay:5];

        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"failure %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
    
}

- (void)reloadAllData:(int)index
{
    _curPage[index] = 1;
    [_kitchenListArray[index] removeAllObjects];
    _sessionId[index] = @"";
    //[_bottomControllers[index].tableView clearAllLoadedState];
    [self updateAllLoadedState];
    [self realLoadData:index];
}

- (void)loadMoreData:(int)index
{
    [self realLoadData:index];
}

- (NSNumber *)isAllLoaded:(int)index
{
    NSMutableArray *total = _kitchenListArray[index];
    if(total.count) {
        WEModelGetList *model = [total lastObject];
        if (model.PageNumber >= model.PageCount)
            return @YES;
    }
    return @NO;
}

- (BOOL)loadDataIfNeeded:(int)index
{
    NSMutableArray *total = _kitchenListArray[index];
    if(total.count) {
        [self updateBottomTableFrame];
        [_bottomControllers[index].tableView reloadData];
        return YES;
    } else {
        [_scrollView.mj_header beginRefreshing];
        return NO;
    }
}

- (void)loadDataSilent:(int)index
{
    _curPage[index] = 1;
    [_kitchenListArray[index] removeAllObjects];
    _sessionId[index] = @"";
    [self updateAllLoadedState];
    [WENetUtil getListWithSessionId:_sessionId[index] PageNumber:_curPage[index] Mode:sGetListMode[index] Latitude:TEST_Latitude Longitude:TEST_Longitude success:^(NSURLSessionDataTask *task, id responseObject) {
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetList *model = [[WEModelGetList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _sessionId[index] = model.SessionId;
        NSMutableArray *total = _kitchenListArray[index];
        if ([total count] == _curPage[index]-1 && _curPage[index] == model.PageNumber) {
            [total addObject:model];
            _curPage[index]++;
        } else {
            NSLog(@"something error, %d, %d, %d", [total count], _curPage[index], model.PageNumber);
        }
        _bottomControllers[index].dataArray = total;
        
        [_bottomControllers[index].tableView reloadData];
        [self updateBottomTableFrame];
        [self updateAllLoadedState];
        NSLog(@"get list data, page %d, items count %d, at index %d", model.PageNumber, model.Kitchens.count, index);
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"failure %@", errorMsg);
    }];
    
}

- (void)downPull
{
    [self reloadAllData:_curModeIndex];
    [_scrollView.mj_header endRefreshing];
}

- (void)upPull
{
    if ([[self upPullFinished] boolValue]) {
        [_scrollView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self loadMoreData:_curModeIndex];
        [_scrollView.mj_footer endRefreshing];
    }
    
}

- (NSNumber *)upPullFinished
{
    return [self isAllLoaded:_curModeIndex];
}

- (void)updateAllLoadedState
{
    if (![[self upPullFinished] boolValue]) {
        [_scrollView.mj_footer resetNoMoreData];
    } else {
        [_scrollView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)loadTopBanner
{
    [WENetUtil getListForConsumerHomeSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"class %@",[responseObject class]);
        JSONModelError* error = nil;
        WEModelGetListForConsumerHome *model = [[WEModelGetListForConsumerHome alloc] initWithDictionary:responseObject error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        NSLog(@"item count %d", model.BannerList.count);
        NSMutableArray *urls = [NSMutableArray arrayWithCapacity:model.BannerList.count];
        for(int i=0; i<model.BannerList.count; i++) {
            WEModelGetListForConsumerHomeBannerList  *item = [model.BannerList objectAtIndex:i];
            //NSLog(@"DisplayOrder=%@, ImageUrl=%@, Link=%@", item.DisplayOrder, item.ImageUrl, item.Link);
            [urls addObject:item.ImageUrl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"urls %@", urls);
            _cycleScrollView.imageURLStringsGroup = urls;
            
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        
    }];

}


//- (void)viewDidLayoutSubviews {
//    [self.tableView layoutIfNeeded];
//    self.scrollViewHeight.constant = self.tableView.contentSize.height;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    //[self testCrash];
    
    //WEHomeKitchenDishViewController *c = [WEHomeKitchenDishViewController new];
    //[self.navigationController pushViewController:c animated:YES];
}


 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
 {
     //NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
 }

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    WEHomeKitchenListViewController *c = _bottomControllers[index];
    if (!c) {
        c = [WEHomeKitchenListViewController new];
        _bottomControllers[index] = c;
    }
    return c;
}

- (UIImageView *)badgeView:(WMPageController *)pageController atIndex:(NSInteger)index selected:(BOOL)isSelected
{
    UIImageView *v = [UIImageView new];
    NSArray *normalImages = @[@"tab_icon_home_normal",   @"tab_icon_discover_normal",  @"tab_icon_order_normal", @"tab_icon_setting_normal"];
    NSArray *selectImages = @[@"tab_icon_home_selected", @"tab_icon_discover_selected", @"tab_icon_order_selected", @"tab_icon_setting_selected"];
    switch (index) {
        case 0:
            v.frame = CGRectMake(0, 18, 40, 40);
            break;
        case 1:
            v.frame = CGRectMake(0, 22, 35, 35);
            break;
        case 2:
            v.frame = CGRectMake(0, 22, 35, 35);
            break;
        case 3:
            v.frame = CGRectMake(0, 16, 40, 48);
            break;
        default:
            break;
    }
    
    
    if (isSelected) {
        NSString *s = selectImages[index];
        v.image = [UIImage imageNamed:s];
    } else {
        NSString *s = normalImages[index];
        v.image = [UIImage imageNamed:s];
    }
    return v;
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSLog(@"pageController didEnterViewController %@, info %@", viewController, info);
    WEHomeKitchenListViewController *c = (WEHomeKitchenListViewController *)viewController;
    
    //float total = _contentTopHeight + c.tableView.contentSize.height;
    //contentHeightConstraint.equalTo(total);
//    float minHeight = pageController.menuHeight + pageController.menuViewBottomSpace;
//    _pageContentHeightConstraint.equalTo(minHeight + c.tableView.contentSize.height);
//    [pageController setViewFrame:CGRectMake(0, 0, [WEUtil getScreenWidth], minHeight + c.tableView.contentSize.height)];
    
    
    for(int i=0; i<4; i++) {
        if (c == _bottomControllers[i]) {
            _curModeIndex = i;
            break;
        }
    }
    
    [self updateBottomTableFrame];
    [c.tableView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    [self updateAllLoadedState];
    if (_curModeIndex == 2) {
        NSMutableArray *total = _kitchenListArray[_curModeIndex];
        if (total.count) {
            [self loadDataSilent:_curModeIndex];
        } else {
             [self loadDataIfNeeded:_curModeIndex];
        }
        
    } else {
        [self loadDataIfNeeded:_curModeIndex];
    }
//    [self loadDataIfNeeded:_curModeIndex];
    
}

- (void)updateBottomTableFrame
{
    WEHomeKitchenListViewController *c = _bottomControllers[_curModeIndex];
    float minHeight = _pageController.menuHeight + _pageController.menuViewBottomSpace;
    _pageContentHeightConstraint.equalTo(minHeight + c.tableView.contentSize.height);
    [_pageController setViewFrame:CGRectMake(0, 0, [WEUtil getScreenWidth], minHeight + c.tableView.contentSize.height)];
}

- (void)searchButtonTapped:(UIButton *)button
{
    WEHomeSearchViewController *c = [WEHomeSearchViewController new];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)addressTapped:(UIButton *)button
{
    WEHomeSetAddressViewController *c = [WEHomeSetAddressViewController new];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)loadAddress
{
    [WENetUtil GetAddressFromLatLngWitLat:@""
                                      Lng:@""
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      //NSString *address = dict[@"Address"][@"AddressLine1"];
                                      NSDictionary *a = dict[@"Address"];
                                      if ([a isKindOfClass:[NSDictionary class]]) {
                                          NSString *State = a[@"State"];
                                          NSString *City = a[@"City"];
                                          _addressLabel.text = [NSString stringWithFormat:@"%@ %@", City, State];
                                      } else {
                                          _addressLabel.text = nil;
                                      }
                                      
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      _addressLabel.text = nil;
                                  }];
}

- (void)favChanged:(NSNotification *)notif
{
    [self loadDataSilent:1];
}

- (void)testCrash {
    //[[Crashlytics sharedInstance] crash];
    [CrashlyticsKit throwException];
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
