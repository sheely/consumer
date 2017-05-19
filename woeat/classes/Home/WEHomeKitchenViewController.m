//
//  WEHomeKitchenViewController.m
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenViewController.h"
#import "WEUtil.h"
#import "SDCycleScrollView.h"
#import "WENumberStarView.h"
#import "WERoundTextListView.h"
#import "WESegmentControl.h"
#import "WEHomeKitchenViewCellTableViewCell.h"
#import "WEHomeKitchenViewComentCell.h"
#import "WEHomeKitchenStoryViewController.h"
#import "WEHomeKitchenDishViewController.h"
#import "WENetUtil.h"
#import "WEShoppingCartView.h"
#import "WEMainTabBarController.h"
#import "WEModelGetConsumerKitchen.h"
#import "WEModelGetTodayList.h"
#import "WERoundTextView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "WEKitchenCommentListView.h"
#import "MJRefresh.h"
#import "WEModelCommon.h"
#import "UmengStat.h"

#define TAG_CELL_ADD_BUTTON_START  1111

@interface WEHomeKitchenViewController ()
{
    UIScrollView *_scrollView;
    WESegmentControl* _segmentControl;
    UITableView *_dishTableView;
    MASConstraint *_dishTableViewHeightConstraint;
    //UITableView *_commentTableView;
    //MASConstraint *_commentTableViewHeightConstraint;
    WEKitchenCommentListView *_commentTableListView;
    
    WEShoppingCartView *_shoppingCartToday;
    WEShoppingCartView *_shoppingCartTomorrow;
    
    WEModelGetConsumerKitchen *_modelGetConsumerKitchen;
    NSArray *_modelKitchenTagArray;
    WEModelGetTodayList *_modelItemToday;
    WEModelGetTodayList *_modelItemTomorrow;
    
    SDCycleScrollView *_topCycleScrollView;
    UILabel *_kitchenNameLabel;
    UILabel *_kitchenDescLabel;
    WENumberStarView *_starView;
    UILabel *_scoreLabel;
    WERoundTextView *_certView;
    UILabel *_personNameLabel;
    UIImageView *_personImageView;
    
    UILabel *_locationPointLabel;
    UILabel *_locationDistanceLabel;
    WERoundTextListView *_featureListView;
    
    WERoundTextListView *_commentListView;
    UIButton *_rightButton;
}
@end

@implementation WEHomeKitchenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    //self.title = @"老马家加州牛肉面";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    //scroll
    UIScrollView *scrollView = [UIScrollView new];
    [superView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(1);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-20);
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
        //contentHeightConstraint = make.height.equalTo(1000);
    }];
    
    superView = contentView;
    float scrollPhotpHeigh = COND_HEIGHT_480(130, 130);
   /*
    NSArray *imagesURLStrings = @[
                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-01.jpg",
                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-02.jpg",
                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-03.jpg",
                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-04.jpg",
                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-05.jpg",
                                  @"http://doc.woeatapp.com/ui/resource/DummyImages/Kitchen/1080-06.jpg",
                                  ];
    */
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
    _topCycleScrollView = cycleScrollView;

    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:middleLine];
    [middleLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(cycleScrollView.bottom).offset(3);
        make.height.equalTo(1);
    }];
    
    float offsetX = 17;
    UILabel *name = [UILabel new];
    name.backgroundColor = [UIColor clearColor];
    name.textColor = UICOLOR(1, 1, 1);
    name.font = [UIFont systemFontOfSize:17];
    [superView addSubview:name];
    [name sizeToFit];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(middleLine.bottom).offset(15);
    }];
    //name.text = @"老马家加州牛肉面";
    _kitchenNameLabel = name;
    
    UILabel *desc = [UILabel new];
    desc.backgroundColor = [UIColor clearColor];
    desc.textColor = UICOLOR(150, 150, 150);
    name.font = [UIFont systemFontOfSize:14];
    [superView addSubview:desc];
    [desc sizeToFit];
    [desc makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(name.bottom).offset(8);
    }];
    //desc.text = @"LA最棒的牛肉面厨房";
    _kitchenDescLabel = desc;
    
    WENumberStarView *star = [WENumberStarView new];
    //[star setStarFull:3 half:1 empty:1];
    [superView addSubview:star];
    [star makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desc.left);
        make.top.equalTo(desc.bottom).offset(8);
        make.width.equalTo([star getWidth]);
        make.height.equalTo([star getHeight]);
    }];
    _starView = star;
    
    UILabel *score = [UILabel new];
    score.backgroundColor = [UIColor clearColor];
    score.textColor = UICOLOR(150, 150, 150);
    score.font = [UIFont systemFontOfSize:14];
    [superView addSubview:score];
    [score makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(star.right).offset(8);
        make.centerY.equalTo(star.centerY);
        make.width.equalTo(200);
        make.height.equalTo(score.font.pointSize+1);
    }];
    //score.text = @"3.5分";
    _scoreLabel = score;
    
    UILabel *personName = [UILabel new];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = UICOLOR(0, 0, 0);
    personName.font = [UIFont systemFontOfSize:17];
    [superView addSubview:personName];
    [personName sizeToFit];
    [personName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(star.left);
        make.top.equalTo(star.bottom).offset(8);
    }];
    //personName.text = @"Lucy Wong, 香港人";
    _personNameLabel = personName;
    
    WERoundTextView *cert = [WERoundTextView new];
    cert.textBgColor = DARK_ORANGE_COLOR;
    cert.textFont = [UIFont systemFontOfSize:13];
    cert.textInset = UIEdgeInsetsMake(-3, -8, -3, -8);
    cert.cornerRadius = 3;
    [cert setString:@"已认证"];
    [superView addSubview:cert];
    [cert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.right).offset(5);
        make.centerY.equalTo(name.centerY);
        make.width.equalTo([cert getWidth]).priorityHigh();
        make.height.equalTo([cert getHeight]);
    }];
    _certView = cert;
    _certView.hidden = YES;
    
    UIImageView *personView = [UIImageView new];
    personView.backgroundColor = [UIColor lightGrayColor];
    float radius = COND_WIDTH_320(50, 40);
    personView.layer.cornerRadius = radius;
    personView.layer.masksToBounds = YES;
    [superView addSubview:personView];
    [personView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-20);
        make.top.equalTo(name.top).offset(0);
        make.width.equalTo(radius*2);
        make.height.equalTo(radius*2);
    }];
    _personImageView = personView;

    UILabel *kitchenStory = [UILabel new];
    kitchenStory.backgroundColor = [UIColor clearColor];
    kitchenStory.textColor = UICOLOR(100, 100, 100);
    kitchenStory.font = [UIFont systemFontOfSize:15];
    kitchenStory.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:kitchenStory];
    [kitchenStory sizeToFit];
    [kitchenStory makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(personView.centerX);
        make.top.equalTo(personView.bottom).offset(10);
    }];
    kitchenStory.text = @"我的厨房故事";
    
    UIButton *storyButton = [UIButton new];
    storyButton.backgroundColor = [UIColor clearColor];
    [storyButton addTarget:self action:@selector(storyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:storyButton];
    [storyButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(personView.right);
        make.top.equalTo(personView.top);
        make.width.equalTo(personView.width);
        make.bottom.equalTo(kitchenStory.bottom);
    }];
    
    UIImage *locationImg = [UIImage imageNamed:@"icon_location_medium"];
    UIImageView *locationIcon = [UIImageView new];
    locationIcon.image = locationImg;
    [superView addSubview:locationIcon];
    [locationIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.width.equalTo(locationImg.size.width);
        make.top.equalTo(personName.bottom).offset(50);
        make.height.equalTo(locationImg.size.height);
    }];
    
    UILabel *locationPoint = [UILabel new];
    locationPoint.textColor = [UIColor blackColor];
    locationPoint.font = [UIFont systemFontOfSize:14];
    [superView addSubview:locationPoint];
    [locationPoint sizeToFit];
    [locationPoint makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationIcon.right).offset(5);
        make.top.equalTo(locationIcon.top);
    }];
    //locationPoint.text = @"Dockland Sourth, CA";
    _locationPointLabel = locationPoint;
    
    UILabel *locationDistance = [UILabel new];
    locationDistance.textColor = [UIColor grayColor];
    locationDistance.font = [UIFont systemFontOfSize:14];
    [superView addSubview:locationDistance];
    [locationDistance sizeToFit];
    [locationDistance makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationPoint.left);
        make.top.equalTo(locationPoint.bottom).offset(8);
    }];
    //locationDistance.text = @"相距约 1公里以内";
    _locationDistanceLabel = locationDistance;
    
    WERoundTextListView *featureListView = [WERoundTextListView new];
    featureListView.textFont = [UIFont systemFontOfSize:13];
    featureListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    featureListView.cornerRadius = 6;
    featureListView.onlyBorder = NO;
    featureListView.maxWidth = [WEUtil getScreenWidth] - 2*offsetX;
    featureListView.lineSpace = 10;
    featureListView.itemSpace = 8;
    featureListView.textBgColor = DARK_ORANGE_COLOR;
    //[featureListView setStringArray: @[@"可外送", @"可自取"]];

    [superView addSubview:featureListView];
    [featureListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(locationPoint.right).offset(10);
        make.left.greaterThanOrEqualTo(locationDistance.right).offset(10);
        make.right.lessThanOrEqualTo(superView.right);
        make.width.equalTo([featureListView getWidth]);
        make.centerY.equalTo(locationPoint.bottom).offset(3);
        make.height.equalTo([featureListView getHeight]);
    }];
    _featureListView = featureListView;
    
    UIView *featureLine = [UIView new];
    featureLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:featureLine];
    [featureLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(featureListView.bottom).offset(20);
        make.height.equalTo(1);
    }];
    

    UILabel *commentHeader = [UILabel new];
    commentHeader.backgroundColor = [UIColor clearColor];
    commentHeader.font = [UIFont systemFontOfSize:15];
    commentHeader.textColor = [UIColor grayColor];
    [superView addSubview:commentHeader];
    [commentHeader sizeToFit];
    [commentHeader makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(featureLine.bottom).offset(15);
    }];
    //commentHeader.text = @"饭友评论";

    WERoundTextListView *commentListView = [WERoundTextListView new];
    commentListView.textBgColor = UICOLOR(184, 184, 184);
    commentListView.textFont = [UIFont systemFontOfSize:13];
    commentListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    commentListView.cornerRadius = 6;
    commentListView.onlyBorder = NO;
    commentListView.maxWidth = [WEUtil getScreenWidth] - 2*offsetX;
    commentListView.lineSpace = 10;
    commentListView.itemSpace = 10;
    //[commentListView setStringArray: @[@"超赞", @"分量足", @"味道正", @"有赠品", @"太赞了"]];
    
    [superView addSubview:commentListView];
    [commentListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.width.equalTo([commentListView getWidth]);
        make.top.equalTo(commentHeader.bottom).offset(10);
        make.height.equalTo([commentListView getHeight]);
    }];
    _commentListView = commentListView;
    
    
    UIView *commentLine = [UIView new];
    commentLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:commentLine];
    [commentLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(commentListView.bottom).offset(10);
        make.height.equalTo(1);
    }];
    
    WESegmentControl *segment = [[WESegmentControl alloc] initWithItems:@[@"今日菜单", @"预订明日"]];
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [superView addSubview:segment];
    [segment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentLine.bottom).offset(20);
        make.centerX.equalTo(superView.centerX);
        make.width.equalTo([WEUtil getScreenWidth]*0.8);
        make.height.equalTo(25);
    }];
    _segmentControl = segment;
    
    superView = contentView;
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[WEHomeKitchenViewCellTableViewCell class] forCellReuseIdentifier:@"WEHomeKitchenViewCellTableViewCell"];
    [superView addSubview:tableView];
    //_tableMinHeight = [WEUtil getScreenHeight] - 20 - 44 - scrollPhotpHeigh - middleHeigh - featureHeight - commentHeight - locationHeight - segmentHeight - 49;
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.bottom).offset(20);
        //make.bottom.equalTo(superView.bottom).offset(20);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _dishTableViewHeightConstraint = make.height.equalTo(1000);
    }];
    _dishTableView = tableView;
    
    _commentTableListView = [WEKitchenCommentListView new];
    _commentTableListView.kitchenId = _kitchenId;
    _commentTableListView.parentScrollView = _scrollView;
    [superView addSubview:_commentTableListView];
    //_tableMinHeight = [WEUtil getScreenHeight] - 20 - 44 - scrollPhotpHeigh - middleHeigh - featureHeight - commentHeight - locationHeight - segmentHeight - 49;
    [_commentTableListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dishTableView.bottom).offset(10);
        make.bottom.equalTo(superView.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        //_commentTableViewHeightConstraint = make.height.equalTo(1000);
    }];

    
    [self loadConsumerKitchen];
    [self loadKitchenTag];
    [self loadItemToday];
    [self loadItemTomorrow];
    //[self loadComment];
    [_commentTableListView loadDataIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _rightButton = [self addRightNavButton:@"收藏" image:@"icon_collect" target:self selector:@selector(rightButtonTapped:)];
    _rightButton.hidden = YES;
    
    [[WEMainTabBarController sharedInstance] setTabBarHidden:YES animated:NO];
    [UmengStat pageEnter:UMENG_STAT_PAGE_KITCHEN];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self segmentValueChanged:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_shoppingCartToday != nil) {
        [_shoppingCartToday saveItems];
    }
    if (_shoppingCartTomorrow != nil) {
        [_shoppingCartTomorrow saveItems];
    }
    [UmengStat pageLeave:UMENG_STAT_PAGE_KITCHEN];
}

- (void)showShoppingCart
{
    if (_segmentControl.selectedSegmentIndex == 0) {
        _shoppingCartToday.hidden = NO;
        _shoppingCartTomorrow.hidden = YES;
        
        if (!_modelItemToday || !_modelGetConsumerKitchen) {
            NSLog(@"can not show cart, _modelItemToday=%p, _modelGetConsumerKitchen = %p", _modelItemToday, _modelGetConsumerKitchen);
            return;
        }
        
        if (!_shoppingCartToday) {
            _shoppingCartToday = [[WEShoppingCartView alloc] initWithFrame:CGRectZero];
            UIView *superView = self.view;
            [superView addSubview:_shoppingCartToday];
            _shoppingCartToday.kitchenId = _kitchenId;
            _shoppingCartToday.allList = _modelItemToday;
            _shoppingCartToday.isToday = YES;
            _shoppingCartToday.parentController = self;
            _shoppingCartToday.kitchenInfo = _modelGetConsumerKitchen;
            _shoppingCartToday.itemDelegate = self;
            [_shoppingCartToday loadItems];
            [_shoppingCartToday makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(superView.bottom);
                make.left.equalTo(superView.left);
                make.right.equalTo(superView.right);
                make.height.equalTo([_shoppingCartToday getHeight]);
            }];
        } else {
            [_shoppingCartToday loadItems];
            [_shoppingCartToday updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo([_shoppingCartToday getHeight]);
            }];
        }
        
        [self.view bringSubviewToFront:_shoppingCartToday];
    } else {
        _shoppingCartTomorrow.hidden = NO;
        _shoppingCartToday.hidden = YES;
        
        if (!_modelItemTomorrow || !_modelGetConsumerKitchen) {
            NSLog(@"can not show cart, _modelItemTomorrow=%p, _modelGetConsumerKitchen = %p", _modelItemTomorrow, _modelGetConsumerKitchen);
            return;
        }
        
        if (!_shoppingCartTomorrow) {
            _shoppingCartTomorrow = [[WEShoppingCartView alloc] initWithFrame:CGRectZero];
            UIView *superView = self.view;
            [superView addSubview:_shoppingCartTomorrow];
            _shoppingCartTomorrow.kitchenId = _kitchenId;
            _shoppingCartTomorrow.allList = _modelItemTomorrow;
            _shoppingCartTomorrow.isToday = NO;
            _shoppingCartTomorrow.parentController = self;
            _shoppingCartTomorrow.kitchenInfo = _modelGetConsumerKitchen;
            _shoppingCartTomorrow.itemDelegate = self;
            [_shoppingCartTomorrow loadItems];
            [_shoppingCartTomorrow makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(superView.bottom);
                make.left.equalTo(superView.left);
                make.right.equalTo(superView.right);
                make.height.equalTo([_shoppingCartTomorrow getHeight]);
            }];
        } else {
            [_shoppingCartTomorrow loadItems];
            [_shoppingCartTomorrow updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo([_shoppingCartTomorrow getHeight]);
            }];
        }
        
        [self.view bringSubviewToFront:_shoppingCartTomorrow];
    }
}

- (void)hideBottomStatusBar
{
    
}

- (void)loadConsumerKitchen
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取数据，请稍后...";
    [hud show:YES];
    
    [WENetUtil GetConsumerKitchenWithKitchenId:_kitchenId Latitude:TEST_Latitude Longitude:TEST_Longitude success:^(NSURLSessionDataTask *task, id responseObject) {
        [hud hide:YES afterDelay:0];
        
        JSONModelError* error = nil;
        NSDictionary *dict = (NSDictionary *)responseObject;
        WEModelGetConsumerKitchen *model = [[WEModelGetConsumerKitchen alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        //tmp
        if (!model.CanPickup && !model.CanDeliver) {
            model.CanPickup = YES;
        }
        _modelGetConsumerKitchen = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateConsumerKitchen];
            [self showShoppingCart];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}

- (void)updateConsumerKitchen
{
    self.title = _modelGetConsumerKitchen.Name;
    
    if(_modelGetConsumerKitchen.Images) {
        _topCycleScrollView.imageURLStringsGroup = _modelGetConsumerKitchen.Images;
    }
    _kitchenNameLabel.text = _modelGetConsumerKitchen.Name;
    
    int full = _modelGetConsumerKitchen.CustomerRating;
    int half = 0;
//    if ([_modelGetConsumerKitchen.CustomerRating containString:@"."]) {
//        half = 1;
//    }
    if (_modelGetConsumerKitchen.CustomerRating > full) {
        half = 1;
    }
    int empty = 5- full - half;
    [_starView setStarFull:full half:half empty:empty];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分", _modelGetConsumerKitchen.CustomerRating];
    if (_modelGetConsumerKitchen.IsCertified) {
        _certView.hidden = NO;
    } else {
        _certView.hidden = YES;
    }
    _personNameLabel.text = _modelGetConsumerKitchen.ChefName;
    
    NSString *s = _modelGetConsumerKitchen.PortraitImageUrl;
    NSURL *url = [NSURL URLWithString:s];
    [_personImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    _locationPointLabel.text = [NSString stringWithFormat:@"%@, %@", _modelGetConsumerKitchen.City, _modelGetConsumerKitchen.State];
    _locationDistanceLabel.text = _modelGetConsumerKitchen.FormattedDistanceString;
    NSMutableArray *array = [NSMutableArray new];
    if (_modelGetConsumerKitchen.CanDeliver) {
        [array addObject:@"可外送"];
    }
    if (_modelGetConsumerKitchen.CanPickup) {
        [array addObject:@"可自取"];
    }
    [_featureListView setStringArray:array];
    [_featureListView updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([_featureListView getWidth]);
        make.height.equalTo([_featureListView getHeight]);
    }];
    
    if (_modelGetConsumerKitchen.IsMyFavourite) {
        _rightButton.hidden = YES;
    } else {
        _rightButton.hidden = NO;
    }
}

//- (void)loadKitchenTag
//{
//    [WENetUtil GetTagListForKitchenWithKitchenId:_kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
//        JSONModelError* error = nil;
//        _modelKitchenTagArray = (NSArray *)[responseObject objectForKey:@"TagList"];
//        for(NSString *tag in _modelKitchenTagArray) {
//            NSLog(@"tag %@", tag);
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateKitchenTag];
//        });
//        
//    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
//        NSLog(@"errorMsg %@", errorMsg);
//    }];
//}

- (void)loadKitchenTag
{
    [WENetUtil GetCommentTagListOfKitchenWithKitchenId:_kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        _modelKitchenTagArray = (NSArray *)[responseObject objectForKey:@"StringList"];
        for(NSString *tag in _modelKitchenTagArray) {
            NSLog(@"tag %@", tag);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateKitchenTag];
        });

    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
    }];
}

- (void)updateKitchenTag
{
    [_commentListView setStringArray:_modelKitchenTagArray];
    [_commentListView updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([_commentListView getWidth]);
        make.height.equalTo([_commentListView getHeight]);
    }];
}

- (void)loadItemToday
{
    [WENetUtil GetItemTodayWithKitchenId:_kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
        
        JSONModelError* error = nil;
        NSDictionary *dict = responseObject;
        WEModelGetTodayList *model = [[WEModelGetTodayList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        NSLog(@"today item count %d", model.ItemList.count);
        _modelItemToday = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self segmentValueChanged:_segmentControl];
        });

        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
    }];
}

- (void)loadItemTomorrow
{
    [WENetUtil GetItemTomorrowWithKitchenId:_kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
        JSONModelError* error = nil;
        NSDictionary *dict = responseObject;
        WEModelGetTodayList *model = [[WEModelGetTodayList alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        NSLog(@"tomorrow item count %d", model.ItemList.count);
        _modelItemTomorrow = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateKitchenTag];
            [self showShoppingCart];
        });

        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
    }];
}

- (void)rightButtonTapped:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在加入收藏，请稍后...";
    [hud show:YES];
    
    [WENetUtil UserFavouriteAddKitchenWithKitchenId:_kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        JSONModelError* error = nil;
        WEModelCommon *res = [[WEModelCommon alloc] initWithDictionary:dict error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (!res.IsSuccessful) {
            hud.labelText = res.ResponseMessage;
            [hud hide:YES afterDelay:1.5];
            return;
        }
        hud.labelText = @"加入成功";
        [hud hide:YES afterDelay:1.0];
        _rightButton.hidden = YES;
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KITCHEN_FAV_CHANGE object:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
        hud.labelText = errorMsg;
        [hud hide:YES afterDelay:1.5];
    }];
}


- (void)segmentValueChanged:(WESegmentControl *)control
{
    [_dishTableView reloadData];
    _dishTableViewHeightConstraint.equalTo( _dishTableView.contentSize.height );
    
    //_commentTableViewHeightConstraint.equalTo(_commentTableView.contentSize.height);
    [self showShoppingCart];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _dishTableView) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (_segmentControl.selectedSegmentIndex == 0) {
        return [_modelItemToday.ItemList count];
    } else {
        return [_modelItemTomorrow.ItemList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (WEModelGetTodayListItemList *)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEModelGetTodayListItemList *item;
    if (_segmentControl.selectedSegmentIndex == 0) {
        item = [_modelItemToday.ItemList objectAtIndex:indexPath.row];
    } else {
        item = [_modelItemTomorrow.ItemList objectAtIndex:indexPath.row];
    }
    return item;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEHomeKitchenViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEHomeKitchenViewCellTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [WEHomeKitchenViewCellTableViewCell new];
    }
//        if (indexPath.row % 2) {
//            cell.isEmpty = YES;
//        } else {
//            cell.isEmpty = NO;
//        }
    WEModelGetTodayListItemList *item = [self getItemAtIndexPath:indexPath];
    [cell.addButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    cell.addButton.tag = TAG_CELL_ADD_BUTTON_START + indexPath.row;
    [cell.addButton addTarget:self action:@selector(cellAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell setModel:item];
    int count = item.CurrentAvailability;
    if (_segmentControl.selectedSegmentIndex == 0) {
        count -= [_shoppingCartToday getItemSelectCount:item.Id];
    } else {
        count -= [_shoppingCartTomorrow getItemSelectCount:item.Id];
    }
    [cell setCurrentAmount:count];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _dishTableView) {
        WEHomeKitchenDishViewController *c = [WEHomeKitchenDishViewController new];
        WEModelGetTodayListItemList *item = [self getItemAtIndexPath:indexPath];
        c.itemId = item.Id;
        c.kitchenId = _kitchenId;
        c.modelItemToday = _modelItemToday;
        c.modelItemTomorrow = _modelItemTomorrow;
        c.modelGetConsumerKitchen = _modelGetConsumerKitchen;
        [self.navigationController pushViewController:c animated:YES];
    }
    
}

- (void)storyButtonTapped:(UIButton *)button
{
    WEHomeKitchenStoryViewController *c = [WEHomeKitchenStoryViewController new];
    c.kitchenId = _kitchenId;
    c.modelGetConsumerKitchen = _modelGetConsumerKitchen;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cellAddButtonTapped:(UIButton *)button
{
    int row = button.tag - TAG_CELL_ADD_BUTTON_START;
    WEModelGetTodayListItemList *item = [self getItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    if (_segmentControl.selectedSegmentIndex == 0) {
        [_shoppingCartToday addItem:item.Id];
    } else {
        [_shoppingCartTomorrow addItem:item.Id];
    }
}

//- (void)loadComment
//{
//    
//    [WENetUtil GetCommentListOpenWithPageIndex:1
//                                      Pagesize:15
//                                     kitchenId:_kitchenId
//                                       success:^(NSURLSessionDataTask *task, id responseObject) {
//                                           
//                                       } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
//                                           
//                                       }];
//    
//}

- (void)itemAddOrMinus:(NSString *)itemId cartView:(WEShoppingCartView *)cartView
{
    [_dishTableView reloadData];
}

@end
