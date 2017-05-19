//
//  WEHomeKitchenDishViewController.m
//  woeat
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenDishViewController.h"
#import "WEUtil.h"
#import "SDCycleScrollView.h"
#import "WENumberStarView.h"
#import "WERoundTextListView.h"
#import "WESegmentControl.h"
#import "WERoundTextView.h"
#import "UIImageView+WebCache.h"
#import "WEHomeKitchenViewComentCell.h"
#import "WETwoLineListView.h"
#import "WEShoppingCartView.h"
#import "WEMainTabBarController.h"
#import "WEKitchenCommentListView.h"
#import "WEHomeKitchenComment.h"
#import "WENetUtil.h"
#import "WEModelGetConsumerItem.h"
#import "WEKitchenDishOtherCollectionCell.h"
#import "WEModelGetConsumerKitchen.h"
#import "WEModelGetTodayList.h"
#import "MBProgressHUD.h"
#import "WEModelGetAllItemListByKitchenId.h"
#import "UmengStat.h"

#define COLLECTION_CELL_WIDTH   ([WEUtil getScreenWidth] * 0.4)
#define COLLECTION_CELL_HEIGHT  ([WEUtil getScreenWidth] * 0.4 + 60)

#define TAG_CELL_ADD_BUTTON_START  1111


@interface WEHomeKitchenDishViewController ()
{
    UIScrollView *_scrollView;

    UICollectionView *_otherDishCollectView;
    MASConstraint *_dishCollectViewHeightConstraint;
    
    //UITableView *_commentTableView;
    //MASConstraint *_commentTableViewHeightConstraint;
    WEKitchenCommentListView *_commentTableListView;
    
    WEModelGetConsumerItem* _modelGetConsumerItem;
    WEShoppingCartView *_shoppingCartToday;
    WEShoppingCartView *_shoppingCartTomorrow;
    
    UIImageView *_topImageView;
    UILabel *_dishNameLabel;
    WERoundTextView *_featureView;
    UILabel *_scoreLabel;
    WESegmentControl *_segment;
    UILabel *_priceLabel;
    UILabel *_amountLabel;
    UILabel *_descContentLabel;
    MASConstraint *_descContentHeightConstraint;
    UILabel *_kitchenNameLabel;
    UILabel *_kitchenDescLabel;
    UILabel *_kitchenScoreLabel;
    UILabel *_personNameLabel;
    UIImageView *_personView;
    WETwoLineListView *_twoLineList;
    WENumberStarView *_starView;
    
    WEModelGetAllItemListByKitchenId* _kitcheItems;
    
    float _topImageViewHeight;
    MASConstraint *_topImageWidthConstraint;
}
@end

@implementation WEHomeKitchenDishViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    //self.title = @"毛氏红烧肉";
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
        //contentHeightConstraint = make.height.equalTo(1000);
    }];
    
    superView = contentView;
    
    UIImage *topBg = [UIImage imageNamed:@"dish_image_top_bg"];
    float topImageHeight = COND_HEIGHT_480(130, 130);
    float topBgWidth = topBg.size.width;
    float topBgHeight = topBg.size.height;
    if (topBgWidth && topBgHeight) {
        topImageHeight = [WEUtil getScreenWidth] * topBgHeight / topBgWidth;
    }
    UIImageView *topBgView = [UIImageView new];
    topBgView.backgroundColor = [UIColor clearColor];
    topBgView.image = topBg;
    [superView addSubview:topBgView];
    [topBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(topImageHeight);
    }];
    
    float topSpace = 8;
    float bottomSpace = 10;
    _topImageViewHeight = topImageHeight - topSpace - bottomSpace;
    UIImageView *topImageView = [UIImageView new];
    topImageView.backgroundColor = [UIColor clearColor];
    topImageView.contentMode =UIViewContentModeScaleAspectFit;
    [superView addSubview:topImageView];
    [topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBgView.top).offset(topSpace);
        make.centerX.equalTo(topBgView.centerX);
        _topImageWidthConstraint = make.width.equalTo(topBgView.width);
        make.height.equalTo(_topImageViewHeight);
    }];
//    NSString *s = @"http://doc.woeatapp.com/ui/resource/DummyImages/Dishes/01.jpg";
//    NSURL *url = [NSURL URLWithString:s];
//    [topImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _topImageView = topImageView;
    
    
//    UIView *middleLine = [UIView new];
//    middleLine.backgroundColor = UICOLOR(184, 184, 184);
//    [superView addSubview:middleLine];
//    [middleLine makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left);
//        make.right.equalTo(superView.right);
//        make.bottom.equalTo(topBgView.bottom).offset(3);
//        make.height.equalTo(1);
//    }];
    
    float offsetX = 15;
    UILabel *name = [UILabel new];
    name.backgroundColor = [UIColor clearColor];
    name.textColor = UICOLOR(1, 1, 1);
    name.font = [UIFont systemFontOfSize:20];
    [superView addSubview:name];
    [name sizeToFit];
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(topBgView.bottom).offset(20);
    }];
    //name.text = @"毛氏红烧肉";
    _dishNameLabel = name;
    
    WERoundTextView *cert = [WERoundTextView new];
    cert.textBgColor = DARK_ORANGE_COLOR;
    cert.textFont = [UIFont systemFontOfSize:11];
    cert.textInset = UIEdgeInsetsMake(-1, -5, -1, -5);
    cert.cornerRadius = 3;
    [cert setString:@"招牌菜"];
    [superView addSubview:cert];
    [cert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.right).offset(10);
        make.centerY.equalTo(name.centerY);
        make.width.equalTo([cert getWidth]).priorityHigh();
        make.height.equalTo([cert getHeight]);
    }];
    _featureView = cert;
    _featureView.hidden = YES;
    
    UILabel *score = [UILabel new];
    score.backgroundColor = [UIColor clearColor];
    score.textColor = UICOLOR(150, 150, 150);
    score.font = [UIFont systemFontOfSize:15];
    [superView addSubview:score];
    [score sizeToFit];
    [score makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(name.bottom).offset(5);
    }];
    //score.text = @"172品尝|32人点赞";
    _scoreLabel = score;
    
    WESegmentControl *segment = [[WESegmentControl alloc] initWithItems:@[@"今日就餐", @"预订明日"]];
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [superView addSubview:segment];
    [segment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(score.bottom).offset(15);
        make.left.equalTo(score.left);
        make.height.equalTo(30);
        make.width.equalTo(150);
    }];
    _segment = segment;
    
    UILabel *price = [UILabel new];
    price.backgroundColor = [UIColor clearColor];
    price.textColor = DARK_ORANGE_COLOR;
    price.font = [UIFont systemFontOfSize:15];
    [superView addSubview:price];
    [price sizeToFit];
    [price makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offsetX);
        make.centerY.equalTo(segment.centerY);
    }];
    //price.text = @"$ 25.00";
    _priceLabel = price;
    
    UILabel *amount = [UILabel new];
    amount.backgroundColor = [UIColor clearColor];
    amount.textColor = UICOLOR(0, 0, 0);
    amount.font = [UIFont systemFontOfSize:15];
    [superView addSubview:amount];
    [amount sizeToFit];
    [amount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(segment.left);
        make.top.equalTo(segment.bottom).offset(20);
    }];
    //amount.text = @"还有5份";
    _amountLabel = amount;
    
    UIImage *addImg = [UIImage imageNamed:@"icon_plus"];
    UIButton *addButton = [UIButton new];
    [addButton setBackgroundImage:addImg forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addSelfTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(amount.centerY);
        make.width.equalTo(addImg.size.width);
        make.height.equalTo(addImg.size.height);
        make.right.equalTo(price.right);
    }];

    UIView *descTopLine = [UIView new];
    descTopLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:descTopLine];
    [descTopLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(addButton.bottom).offset(15);
        make.height.equalTo(1);
    }];
    
    UILabel *descHeader = [UILabel new];
    descHeader.backgroundColor = [UIColor clearColor];
    descHeader.textColor = UICOLOR(0, 0, 0);
    descHeader.font = [UIFont systemFontOfSize:15];
    [superView addSubview:descHeader];
    [descHeader sizeToFit];
    [descHeader makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descTopLine.left);
        make.top.equalTo(descTopLine.bottom).offset(15);
    }];
    descHeader.text = @"菜品描述";
    
//    NSString *desc = @"每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。\n\n每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。";
    UILabel *descContent = [UILabel new];
    descContent.numberOfLines = 0;
    descContent.textAlignment = NSTextAlignmentLeft;
    descContent.lineBreakMode = NSLineBreakByWordWrapping;
    descContent.font = [UIFont systemFontOfSize:15];
    descContent.textColor = UICOLOR(180, 180, 180);
    //descContent.text = desc;
    [superView addSubview:descContent];
    float storyOffsetX = 15;
    float storyContentWidth = [WEUtil getScreenWidth] - storyOffsetX - storyOffsetX;
    CGSize storyContentSize = [WEUtil sizeForTitle:descContent.text font:descContent.font maxWidth:storyContentWidth];
    [descContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(storyOffsetX);
        make.top.equalTo(descHeader.bottom).offset(10);
        make.width.equalTo(storyContentWidth);
        _descContentHeightConstraint = make.height.equalTo(storyContentSize.height);
    }];
    _descContentLabel = descContent;
    
    UIView *descBottomLine = [UIView new];
    descBottomLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:descBottomLine];
    [descBottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(descContent.bottom).offset(20);
        make.height.equalTo(1);
    }];
    
    UILabel *kitchenName = [UILabel new];
    kitchenName.backgroundColor = [UIColor clearColor];
    kitchenName.textColor = UICOLOR(1, 1, 1);
    kitchenName.font = [UIFont systemFontOfSize:17];
    [superView addSubview:kitchenName];
    [kitchenName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(descBottomLine.bottom).offset(15);
        make.width.equalTo(200);
        make.height.equalTo(kitchenName.font.pointSize+1);
    }];
    //kitchenName.text = @"老马家加州牛肉面";
    _kitchenNameLabel = kitchenName;
    
    UILabel *kitchenDesc = [UILabel new];
    kitchenDesc.backgroundColor = [UIColor clearColor];
    kitchenDesc.textColor = UICOLOR(150, 150, 150);
    kitchenDesc.font = [UIFont systemFontOfSize:14];
    [superView addSubview:kitchenDesc];
    [kitchenDesc makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenName.left);
        make.top.equalTo(kitchenName.bottom).offset(5);
        make.width.equalTo(200);
        make.height.equalTo(kitchenDesc.font.pointSize+1);
    }];
    //kitchenDesc.text = @"LA最棒的牛肉面厨房";
    _kitchenDescLabel = kitchenDesc;
    
    WENumberStarView *kitchenStar = [WENumberStarView new];
    [kitchenStar setStarFull:3 half:1 empty:1];
    [superView addSubview:kitchenStar];
    [kitchenStar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenDesc.left);
        make.top.equalTo(kitchenDesc.bottom).offset(5);
        make.width.equalTo([kitchenStar getWidth]);
        make.height.equalTo([kitchenStar getHeight]);
    }];
    _starView = kitchenStar;
    
    UILabel *kitchenScore = [UILabel new];
    kitchenScore.backgroundColor = [UIColor clearColor];
    kitchenScore.textColor = UICOLOR(150, 150, 150);
    kitchenScore.font = [UIFont systemFontOfSize:14];
    [superView addSubview:kitchenScore];
    [kitchenScore makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenStar.right).offset(5);
        make.centerY.equalTo(kitchenStar.centerY);
        make.width.equalTo(200);
        make.height.equalTo(kitchenScore.font.pointSize+1);
    }];
    //kitchenScore.text = @"4.4分";
    _kitchenScoreLabel = kitchenScore;
    
    UILabel *personName = [UILabel new];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = UICOLOR(0, 0, 0);
    personName.font = [UIFont systemFontOfSize:17];
    [superView addSubview:personName];
    [personName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenStar.left);
        make.top.equalTo(kitchenStar.bottom).offset(5);
        make.width.equalTo(200);
        make.height.equalTo(personName.font.pointSize+1);
    }];
    //personName.text = @"Lucy Wong, 香港人";
    _personNameLabel = personName;
    
    UIImageView *personView = [UIImageView new];
    personView.backgroundColor = [UIColor lightGrayColor];
    float radius = COND_WIDTH_320(50, 40);
    personView.layer.cornerRadius = radius;
    personView.layer.masksToBounds = YES;
    [superView addSubview:personView];
    [personView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-20);
        make.top.equalTo(kitchenName.top);
        make.width.equalTo(radius*2);
        make.height.equalTo(radius*2);
    }];
    _personView = personView;

    UIButton *personViewButton = [UIButton new];
    personViewButton.backgroundColor = [UIColor clearColor];
    //[personViewButton addTarget:self action:@selector(storyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:personViewButton];
    [personViewButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(personView.right);
        make.top.equalTo(personView.top);
        make.left.equalTo(personView.left);
        make.bottom.equalTo(personView.bottom);
    }];
    
    WETwoLineListView *twoLineList = [WETwoLineListView new];
    twoLineList.upFont = [UIFont systemFontOfSize:14];
    twoLineList.downFont = [UIFont boldSystemFontOfSize:15];
    twoLineList.upColor = [UIColor lightGrayColor];
    twoLineList.downColor = [UIColor blackColor];
    twoLineList.leftPadding = COND_WIDTH_320(15,10);
    twoLineList.rightPadding = COND_WIDTH_320(15,10);
    twoLineList.topPadding = 6;
    twoLineList.bottomPadding = 6;
    twoLineList.middleYPadding = 5;
    twoLineList.lineColor = [UIColor lightGrayColor];
    twoLineList.lineWidth = 2;
    [superView addSubview:twoLineList];
    NSArray *ups = @[@"月售", @"好评", @"被收藏"];
    //NSArray *downs = @[@"300 +", @"4500", @"1342"];
    NSArray *downs = @[@"     ", @"    ", @"    "];
    [twoLineList setUpText:ups downText:downs];
    [twoLineList makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personName.left);
        make.top.equalTo(personView.bottom).offset(30);
        make.width.equalTo([twoLineList getWidth]);
        make.height.equalTo([twoLineList getHeight]);
    }];
    _twoLineList = twoLineList;

    NSString *title = @"去厨房看看";
    UIButton *goKitchenButton = [UIButton new];
    goKitchenButton.backgroundColor = DARK_ORANGE_COLOR;
    goKitchenButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [goKitchenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goKitchenButton setTitle:title forState:UIControlStateNormal];
    [goKitchenButton addTarget:self action:@selector(goKitchenButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:goKitchenButton];
    CGSize size = [WEUtil oneLineSizeForTitle:title font:goKitchenButton.titleLabel.font];
    [goKitchenButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoLineList.centerY);
        make.centerX.equalTo(personView.centerX);
        make.width.equalTo(size.width+12);
        make.height.equalTo(size.height+6);
    }];
    
    UIView *collectTopLine = [UIView new];
    collectTopLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:collectTopLine];
    [collectTopLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(twoLineList.bottom).offset(10);
        make.height.equalTo(1);
    }];
    
    UILabel *collectHeader = [UILabel new];
    collectHeader.backgroundColor = [UIColor clearColor];
    collectHeader.textColor = UICOLOR(0, 0, 0);
    collectHeader.font = [UIFont systemFontOfSize:15];
    collectHeader.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:collectHeader];
    [collectHeader sizeToFit];
    [collectHeader makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectTopLine.bottom).offset(15);
        make.left.equalTo(collectTopLine.left).offset(3);
    }];
    collectHeader.text = @"此厨房其他美食";
    
    //CGSize itemSize = CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //layout.itemSize = itemSize;
    //layout.footerReferenceSize = CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[WEKitchenDishOtherCollectionCell class] forCellWithReuseIdentifier:@"WEKitchenDishOtherCollectionCell"];
    [superView addSubview:collectionView];
    [collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectHeader.left);
        make.right.equalTo(collectTopLine.right);
        make.top.equalTo(collectHeader.bottom).offset(15);
        _dishCollectViewHeightConstraint = make.height.equalTo(COLLECTION_CELL_HEIGHT*2);
    }];
    _otherDishCollectView = collectionView;
    
    title = @"去厨房看看更多美食";
    UIButton *moreDishButton = [UIButton new];
    moreDishButton.backgroundColor = [UIColor lightGrayColor];
    moreDishButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [moreDishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreDishButton setTitle:title forState:UIControlStateNormal];
    [moreDishButton addTarget:self action:@selector(moreDishButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:moreDishButton];
    size = [WEUtil oneLineSizeForTitle:title font:moreDishButton.titleLabel.font];
    [moreDishButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collectionView.centerX);
        make.top.equalTo(collectionView.bottom).offset(15);
        make.width.equalTo(size.width+12);
        make.height.equalTo(size.height+6);
    }];

    _commentTableListView = [WEKitchenCommentListView new];
    _commentTableListView.kitchenId = _kitchenId;
    _commentTableListView.parentScrollView = _scrollView;
    [superView addSubview:_commentTableListView];
    //_tableMinHeight = [WEUtil getScreenHeight] - 20 - 44 - scrollPhotpHeigh - middleHeigh - featureHeight - commentHeight - locationHeight - segmentHeight - 49;
    [_commentTableListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreDishButton.bottom).offset(15);
        make.bottom.equalTo(superView.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        //_commentTableViewHeightConstraint = make.height.equalTo(1000);
    }];
    
    if (!_modelGetConsumerKitchen) {
        [self loadConsumerKitchen];
    }
    if (!_modelItemToday) {
        [self loadItemToday];
    }
    if (!_modelItemTomorrow) {
        [self loadItemTomorrow];
    }
    [self loadDish];
    [self loadKitchenItems];
    [_commentTableListView loadDataIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[WEMainTabBarController sharedInstance] setTabBarHidden:YES animated:NO];
    [UmengStat pageEnter:UMENG_STAT_PAGE_DISH];
   
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
    [UmengStat pageLeave:UMENG_STAT_PAGE_DISH];
}

- (void)showShoppingCart
{
    if (_segment.selectedSegmentIndex == 0) {
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
        }
        [self.view bringSubviewToFront:_shoppingCartTomorrow];
    }
}

- (void)loadConsumerKitchen
{
    [WENetUtil GetConsumerKitchenWithKitchenId:_kitchenId Latitude:TEST_Latitude Longitude:TEST_Longitude success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
            [self showShoppingCart];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
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
            [self segmentValueChanged:_segment];
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
            [self showShoppingCart];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
    }];
}

- (void)updateCurrentAmount
{
    int count = _modelGetConsumerItem.Item.CurrentAvailability;
    if (_segment.selectedSegmentIndex == 0) {
        count -= [_shoppingCartToday getItemSelectCount:_modelGetConsumerItem.Item.Id];
    } else {
        count -= [_shoppingCartTomorrow getItemSelectCount:_modelGetConsumerItem.Item.Id];
    }
    _amountLabel.text =  [NSString stringWithFormat:@"还有%d份", count];
}

- (void)updateDish
{
    self.title = _modelGetConsumerItem.Item.Name;
    
    NSString *s = _modelGetConsumerItem.Item.PortraitImageUrl;
    NSURL *url = [NSURL URLWithString:s];
    [_topImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //NSLog(@"========error=%@, image size %p, %f,%f", error, image, image.size.width, image.size.height);
        //NSLog(@"_imgView.image %p", _imgView.image);
        float w = image.size.width;
        float h = image.size.height;
        float width = _topImageViewHeight * w / h;
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _topImageWidthConstraint.equalTo(width);
//            [self.view setNeedsLayout];
//                [self.view layoutIfNeeded];
//        });
        
    }];
    
    
    _dishNameLabel.text = _modelGetConsumerItem.Item.Name;
    if (_modelGetConsumerItem.Item.IsFeatured) {
        _featureView.hidden = NO;
    } else {
        _featureView.hidden = YES;
    }
    NSString *sold = [NSString stringWithFormat:@"%d", _modelGetConsumerItem.Item.SoldQtyLifeLong];
    NSString *ok = [NSString stringWithFormat:@"%d", _modelGetConsumerItem.Item.TotalPositiveVotes];
    _scoreLabel.text = [NSString stringWithFormat:@"%@品尝|%@人点赞", sold, ok];
    _priceLabel.text = [NSString stringWithFormat:@"$ %.2f", _modelGetConsumerItem.Item.UnitPrice];
    [self updateCurrentAmount];
    _descContentLabel.text = _modelGetConsumerItem.Item.Description;
    float storyOffsetX = 15;
    float storyContentWidth = [WEUtil getScreenWidth] - storyOffsetX - storyOffsetX;
    CGSize storyContentSize = [WEUtil sizeForTitle:_descContentLabel.text font:_descContentLabel.font maxWidth:storyContentWidth];
    _descContentHeightConstraint.equalTo(storyContentSize.height);
    
    NSString *month = [NSString stringWithFormat:@"%d", _modelGetConsumerItem.Item.SoldQtyMonthToDate];
    NSString *positive = [NSString stringWithFormat:@"%d", _modelGetConsumerItem.Item.TotalPositiveVotes];
    NSString *fav = [NSString stringWithFormat:@"%d", _modelGetConsumerItem.Item.TotalUserFavourites];
    NSArray *ups = @[@"月售", @"好评", @"被收藏"];
    NSArray *downs = @[month, positive, fav];
    [_twoLineList setUpText:ups downText:downs];
    
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
    _kitchenScoreLabel.text = [NSString stringWithFormat:@"%.1f分", _modelGetConsumerKitchen.CustomerRating];
    _personNameLabel.text = _modelGetConsumerKitchen.ChefName;
    
    NSString *s1 = _modelGetConsumerKitchen.PortraitImageUrl;
    NSURL *url1 = [NSURL URLWithString:s1];
    [_personView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

- (void)loadDish
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在获取数据，请稍后...";
    [hud show:YES];
    

    [WENetUtil GetConsumerItemWithItemId:_itemId
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     [hud hide:YES afterDelay:0];
                                     
                                     JSONModelError* error = nil;
                                     NSDictionary *dict = (NSDictionary *)responseObject;
                                     WEModelGetConsumerItem *model = [[WEModelGetConsumerItem alloc] initWithDictionary:dict error:&error];
                                     if (error) {
                                         NSLog(@"error %@", error);
                                     }
                                     if (model.IsSuccessful) {
                                         [hud hide:YES afterDelay:0];
                                         _modelGetConsumerItem = model;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self updateDish];
                                         });
                                         
                                     } else {
                                         hud.labelText = model.ResponseMessage;
                                         [hud hide:YES afterDelay:1.5];
                                     }
                                     
                                 } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                     hud.labelText = errorMsg;
                                     [hud hide:YES afterDelay:1.5];
                                 }];
}

- (void)loadKitchenItems
{
    [WENetUtil GetAllItemListByKitchenIdWithKitchenId:_kitchenId
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  JSONModelError* error = nil;
                                                  NSDictionary *dict = responseObject;
                                                  WEModelGetAllItemListByKitchenId *model = [[WEModelGetAllItemListByKitchenId alloc] initWithDictionary:dict error:&error];
                                                  if (error) {
                                                      NSLog(@"error %@", error);
                                                  }
                                                  NSLog(@"_kitcheItems item count %d", model.ItemList.count);
                                                  _kitcheItems = model;
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_otherDishCollectView reloadData];
                                                      int total = _kitcheItems.ItemList.count-1;
                                                      if (total < 3) {
                                                          _dishCollectViewHeightConstraint.equalTo(COLLECTION_CELL_HEIGHT);
                                                      } else {
                                                          _dishCollectViewHeightConstraint.equalTo(COLLECTION_CELL_HEIGHT*2);
                                                      }
                                                      
                                                  });
                                                  
                                                  
                                              } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                  
                                              }];
}


- (void)segmentValueChanged:(WESegmentControl *)control
{
    [self showShoppingCart];
}

- (WEModelGetAllItemListByKitchenIdItemList *)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    int selfIndex = 0;
    for(int i=0; i<_kitcheItems.ItemList.count; i++) {
        WEModelGetAllItemListByKitchenIdItemList *item = _kitcheItems.ItemList[i];
        if ([item.Id isEqualToString:_itemId]) {
            selfIndex = i;
            break;
        }
    }
    if (indexPath.row < selfIndex) {
        return [_kitcheItems.ItemList objectAtIndex:indexPath.row];
    } else {
        return [_kitcheItems.ItemList objectAtIndex:indexPath.row+1];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    int total = _kitcheItems.ItemList.count-1;
    if (total < 4) {
        return total;
    }
    return 4;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"WEKitchenDishOtherCollectionCell";
    WEKitchenDishOtherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    WEModelGetAllItemListByKitchenIdItemList *item = [self getItemAtIndexPath:indexPath];
    cell.nameLabel.text = item.Name;
    cell.priceLabel.text = [NSString stringWithFormat:@"$ %.2f", item.UnitPrice];
    cell.amountLabel.text = [NSString stringWithFormat:@"还有%d份", item.DailyAvailability];
    if (item.PortraitImageUrl.length) {
        NSString *s = item.PortraitImageUrl;
        NSURL *url = [NSURL URLWithString:s];
        [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    [cell.addButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    cell.addButton.tag = TAG_CELL_ADD_BUTTON_START + indexPath.row;
    [cell.addButton addTarget:self action:@selector(cellAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={0,0};
    return size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    WEModelGetAllItemListByKitchenIdItemList *item = [self getItemAtIndexPath:indexPath];
    UINavigationController *nav = self.navigationController;
    WEHomeKitchenDishViewController *c = [WEHomeKitchenDishViewController new];
    c.itemId = item.Id;
    c.kitchenId = _kitchenId;
    //    c.modelItemToday = _modelItemToday;
    //    c.modelItemTomorrow = _modelItemTomorrow;
    c.modelGetConsumerKitchen = _modelGetConsumerKitchen;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
}


- (void)goKitchenButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreDishButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cellAddButtonTapped:(UIButton *)button
{
    int row = button.tag - TAG_CELL_ADD_BUTTON_START;
    WEModelGetAllItemListByKitchenIdItemList *item = [self getItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    if (_segment.selectedSegmentIndex == 0) {
        [_shoppingCartToday addItem:item.Id];
    } else {
        [_shoppingCartTomorrow addItem:item.Id];
    }
}

- (void)addSelfTapped:(UIButton *)button
{
    if (_segment.selectedSegmentIndex == 0) {
        [_shoppingCartToday addItem:_itemId];
    } else {
        [_shoppingCartTomorrow addItem:_itemId];
    }
}

- (void)itemAddOrMinus:(NSString *)itemId cartView:(WEShoppingCartView *)cartView
{
    [self updateCurrentAmount];
}

@end
