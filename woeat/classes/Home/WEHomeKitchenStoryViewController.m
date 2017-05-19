//
//  WEHomeKitchenStoryViewController.m
//  woeat
//
//  Created by liubin on 16/10/24.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenStoryViewController.h"
#import "WEUtil.h"
#import "SDCycleScrollView.h"
#import "WENumberStarView.h"
#import "WERoundTextListView.h"
#import "WESegmentControl.h"
#import "WEHomeKitchenViewComentCell.h"
#import "WERoundTextView.h"
#import "WEKitchenStoryDishCollectionCell.h"
#import "WEModelGetConsumerKitchen.h"
#import "WEKitchenCommentListView.h"
#import "WENetUtil.h"
#import "WEModelGetAllItemListByKitchenId.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "WEModelCommon.h"
#import "WEHomeKitchenViewController.h"
#import "WEHomeKitchenDishViewController.h"
#import "UmengStat.h"

#define COLLECTION_CELL_WIDTH  70
#define COLLECTION_CELL_HEIGHT 100


@interface WEHomeKitchenStoryViewController ()
{
    UIScrollView *_scrollView;
    WEModelGetConsumerKitchen *_modelGetConsumerKitchen;
    
    SDCycleScrollView *_topCycleScrollView;
    UILabel *_kitchenNameLabel;
    WENumberStarView *_starView;
    UILabel *_scoreLabel;
    WERoundTextView *_certView;
    
    UILabel *_locationPointLabel;
    UILabel *_locationDistanceLabel;
    WERoundTextListView *_featureListView;
    
    WERoundTextListView *_commentListView;
    UIButton *_rightButton;
    
    UILabel *_storyContent;
    
    //int _favCount;
    UICollectionView *_favCollectView;
    WEModelGetAllItemListByKitchenId* _kitcheItems;
    
    WEKitchenCommentListView *_commentTableListView;
}
@end

@implementation WEHomeKitchenStoryViewController

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
    float scrollPhotpHeigh = COND_HEIGHT_480(130, 130);
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
    
//    float middleHeigh = COND_WIDTH_320(150, 130);;
//    UIView *middleBg = [UIView new];
//    [superView addSubview:middleBg];
//    [middleBg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cycleScrollView.bottom).offset(0);
//        make.left.equalTo(superView.left);
//        make.right.equalTo(superView.right);
//        make.height.equalTo(middleHeigh);
//    }];
//    
//    superView = middleBg;
    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:middleLine];
    [middleLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(cycleScrollView.bottom).offset(3);
        make.height.equalTo(1);
    }];
    
    float offsetX = 15;
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
    //name.text = @"Lucy Wong, 香港人";
    _kitchenNameLabel = name;
    
    WERoundTextView *cert = [WERoundTextView new];
    cert.textBgColor = DARK_ORANGE_COLOR;
    cert.textFont = [UIFont systemFontOfSize:13];
    cert.textInset = UIEdgeInsetsMake(-6, -10, -6, -10);
    cert.cornerRadius = 6;
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
    
    WENumberStarView *star = [WENumberStarView new];
    [star setStarFull:3 half:1 empty:1];
    [superView addSubview:star];
    [star makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(name.bottom).offset(5);
        make.width.equalTo([star getWidth]);
        make.height.equalTo([star getHeight]);
    }];
    _starView = star;
    
    UILabel *score = [UILabel new];
    score.backgroundColor = [UIColor clearColor];
    score.textColor = UICOLOR(150, 150, 150);
    score.font = [UIFont systemFontOfSize:14];
    [superView addSubview:score];
    [score sizeToFit];
    [score makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(star.right).offset(5);
        make.centerY.equalTo(star.centerY);
    }];
    //score.text = @"4.4分";
    _scoreLabel = score;
    
    UIImage *locationImg = [UIImage imageNamed:@"icon_location_medium"];
    UIImageView *locationIcon = [UIImageView new];
    locationIcon.image = locationImg;
    [superView addSubview:locationIcon];
    [locationIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.width.equalTo(locationImg.size.width);
        make.top.equalTo(star.bottom).offset(20);
        make.height.equalTo(locationImg.size.height);
    }];
    
    UILabel *locationPoint = [UILabel new];
    locationPoint.textColor = [UIColor blackColor];
    locationPoint.font = [UIFont systemFontOfSize:14];
    locationPoint.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:locationPoint];
    [locationPoint sizeToFit];
    [locationPoint makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationIcon.right).offset(10);
        make.top.equalTo(locationIcon.top).offset(0);
    }];
    //locationPoint.text = @"Dockland Sourth, CA";
    _locationPointLabel = locationPoint;
    CGSize size1 = [locationPoint.text sizeWithAttributes:@{NSFontAttributeName : locationPoint.font}];
    
    UILabel *locationDistance = [UILabel new];
    locationDistance.textColor = [UIColor grayColor];
    locationDistance.font = [UIFont systemFontOfSize:14];
    locationDistance.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:locationDistance];
    [locationDistance sizeToFit];
    [locationDistance makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationPoint.left);
        make.top.equalTo(locationPoint.bottom).offset(20);
    }];
    //locationDistance.text = @"相距约 1公里以内";
    CGSize size2 = [locationDistance.text sizeWithAttributes:@{NSFontAttributeName : locationDistance.font}];
    _locationDistanceLabel = locationDistance;
    
    float featureX = locationImg.size.width + 15 + MAX(size1.width, size2.width) + COND_WIDTH_320(15, 0);
    WERoundTextListView *featureListView = [WERoundTextListView new];
    featureListView.textFont = [UIFont systemFontOfSize:13];
    featureListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    featureListView.cornerRadius = 6;
    featureListView.onlyBorder = NO;
    featureListView.maxWidth = [WEUtil getScreenWidth] - 2*offsetX;
    featureListView.lineSpace = 10;
    featureListView.itemSpace = COND_WIDTH_320(10,5);
    featureListView.textBgColor = DARK_ORANGE_COLOR;
    //[featureListView setStringArray: @[@"可外送", @"可自取"]];
    [superView addSubview:featureListView];
    [featureListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left).offset(featureX);
        make.width.equalTo([featureListView getWidth]);
        make.top.equalTo(locationPoint.bottom).offset(-3);
        make.height.equalTo([featureListView getHeight]);
    }];
    
    UIView *storyTopLine = [UIView new];
    storyTopLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:storyTopLine];
    [storyTopLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(locationDistance.bottom).offset(20);
        make.height.equalTo(1);
    }];
    
//    NSString *story = @"每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。\n\n每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。每天清晨，叫醒我的不是闹钟。";
    UILabel *storyContent = [UILabel new];
    storyContent.numberOfLines = 0;
    storyContent.textAlignment = NSTextAlignmentLeft;
    storyContent.lineBreakMode = NSLineBreakByWordWrapping;
    storyContent.font = [UIFont systemFontOfSize:15];
    storyContent.textColor = UICOLOR(180, 180, 180);
    //storyContent.text = story;
    [superView addSubview:storyContent];
    float storyOffsetX = 18;
    float storyContentWidth = [WEUtil getScreenWidth] - storyOffsetX - storyOffsetX;
    CGSize storyContentSize = [WEUtil sizeForTitle:storyContent.text font:storyContent.font maxWidth:storyContentWidth];
    [storyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(storyOffsetX);
        make.top.equalTo(storyTopLine.bottom).offset(20);
        make.width.equalTo(storyContentWidth);
        make.height.equalTo(storyContentSize.height);
    }];
    _storyContent = storyContent;
    
    UIView *storyBottomLine = [UIView new];
    storyBottomLine.backgroundColor = UICOLOR(184, 184, 184);
    [superView addSubview:storyBottomLine];
    [storyBottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(storyContent.bottom).offset(20);
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
        make.top.equalTo(storyBottomLine.bottom).offset(15);
        make.left.equalTo(storyBottomLine.left).offset(3);
    }];
    collectHeader.text = @"招牌菜";
    
    CGSize itemSize = CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    //layout.footerReferenceSize = CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WEKitchenStoryDishCollectionCell class] forCellWithReuseIdentifier:@"WEKitchenStoryDishCollectionCell"];
    [collectionView registerClass:[WEKitchenStoryDishCollectionCellFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WEKitchenStoryDishCollectionCellFooter"];
    [superView addSubview:collectionView];
    [collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectHeader.left);
        make.right.equalTo(storyBottomLine.right).offset(-3);
        make.top.equalTo(collectHeader.bottom).offset(10);
        make.height.equalTo(100);
    }];
    _favCollectView = collectionView;
    
    _commentTableListView = [WEKitchenCommentListView new];
    _commentTableListView.kitchenId = _kitchenId;
    _commentTableListView.parentScrollView = _scrollView;
    [superView addSubview:_commentTableListView];
    //_tableMinHeight = [WEUtil getScreenHeight] - 20 - 44 - scrollPhotpHeigh - middleHeigh - featureHeight - commentHeight - locationHeight - segmentHeight - 49;
    [_commentTableListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_favCollectView.bottom).offset(10);
        make.bottom.equalTo(superView.bottom).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        //_commentTableViewHeightConstraint = make.height.equalTo(1000);
    }];

    if (!_modelGetConsumerKitchen) {
        [self loadConsumerKitchen];
    } else {
        [self updateConsumerKitchen];
    }
    [self loadKitchenItems];
    [_commentTableListView loadDataIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _rightButton = [self addRightNavButton:@"收藏" image:@"icon_collect" target:self selector:@selector(rightButtonTapped:)];
    [UmengStat pageEnter:UMENG_STAT_PAGE_KITCHEN_STORY];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_KITCHEN_STORY];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    
    _storyContent.text = _modelGetConsumerKitchen.KitchenStory;
    float storyOffsetX = 18;
    float storyContentWidth = [WEUtil getScreenWidth] - storyOffsetX - storyOffsetX;
    CGSize storyContentSize = [WEUtil sizeForTitle:_storyContent.text font:_storyContent.font maxWidth:storyContentWidth];
    [_storyContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(storyContentSize.height);
    }];

    
    if (_modelGetConsumerKitchen.IsMyFavourite) {
        _rightButton.hidden = YES;
    } else {
        _rightButton.hidden = NO;
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
        
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        NSLog(@"errorMsg %@", errorMsg);
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
                                                      [_favCollectView reloadData];
                                                  });
                                                  
                                                  
                                              } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                                  
                                              }];
}

- (WEModelGetAllItemListByKitchenIdItemList *)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    int favIndex = -1;
    int i;
    for(i=0; i<_kitcheItems.ItemList.count; i++) {
        WEModelGetAllItemListByKitchenIdItemList *item = _kitcheItems.ItemList[i];
        if (item.IsFeatured) {
            favIndex++;
            if (favIndex == indexPath.row) {
                break;
            }
        }
        
    }
    return [_kitcheItems.ItemList objectAtIndex:i];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    int favNum = 0;
    int i;
    for(i=0; i<_kitcheItems.ItemList.count; i++) {
        WEModelGetAllItemListByKitchenIdItemList *item = _kitcheItems.ItemList[i];
        if (item.IsFeatured) {
            favNum++;
        }
    }
    return favNum;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"WEKitchenStoryDishCollectionCell";
    WEKitchenStoryDishCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    WEModelGetAllItemListByKitchenIdItemList *item = [self getItemAtIndexPath:indexPath];
    cell.titleLabel.text = item.Name;
    if (item.PortraitImageUrl.length) {
        NSString *s = item.PortraitImageUrl;
        NSURL *url = [NSURL URLWithString:s];
        [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *reuseIdentifier;
//    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
//        reuseIdentifier = @"WEKitchenStoryDishCollectionCellFooter";
//    }else{
//        reuseIdentifier = @"WEKitchenStoryDishCollectionCellFooter";
//    }
//    
//    WEKitchenStoryDishCollectionCellFooter *view =  (WEKitchenStoryDishCollectionCellFooter *)[collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
//    
//    [view.button setTitle:@"更多" forState:UIControlStateNormal];
//    [view.button addTarget:self action:@selector(loadMoreFav:) forControlEvents:UIControlEventTouchUpInside];
//    return view;
//}

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

- (void)scrollFav:(NSNumber *)row
{
     [_favCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[row integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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

//- (void)loadMoreFav:(UIButton *)button
//{
//    if (_favCount < 9){
//        _favCount += 3;
//        [self performSelector:@selector(scrollFav:) withObject:@(_favCount-2) afterDelay:0.01];
//    }
//    [_favCollectView reloadData];
//}


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
