//
//  WEOrderAddCommentViewController.m
//  woeat
//
//  Created by liubin on 16/11/17.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderAddCommentViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "WEOrderDishCell.h"
#import "UIImageView+WebCache.h"
#import "TNRadioButtonGroup.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "WERoundTextListView.h"
#import "WENetUtil.h"
#import "WEGlobalData.h"
#import "WEOrderDishListView.h"
#import "WEMainTabBarController.h"
#import "WEModelOrder.h"
#import "WEModelGetConsumerKitchen.h"
#import "WEOrderstatus.h"
#import "MBProgressHUD.h"
#import "WEModelCommon.h"

@interface WEOrderAddCommentViewController ()
{
    UIScrollView *_scrollView;
    
    UITableView *_commentTableView;
    MASConstraint *_commentTableViewHeightConstraint;

    WEOrderDishListView *_dishListView;
    MASConstraint *_dishListViewHeightConstraint;
    
    UITextView *_commentTextView;
    NSString *_commentContent;
    float _commentTextHeight;
    TNRadioButtonGroup *_checkGroup;
    int _radioIndex;
    BOOL _placeHolder;
    
    WERoundTextListView *_quickCommentList;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end


@implementation WEOrderAddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler = nil;
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDefault;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    //[IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 50;
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"添加评论";
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
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _commentTableViewHeightConstraint = make.height.equalTo(400);
    }];
    _commentTableView = tableView;
    
    WEOrderDishListView *dishListView = [WEOrderDishListView new];
    dishListView.showHeader = YES;
    [superView addSubview:dishListView];
    [dishListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentTableView.bottom).offset(10);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _dishListViewHeightConstraint = make.height.equalTo(200);
        make.bottom.equalTo(superView.bottom).offset(-20);
    }];
    _dishListView = dishListView;
    _dishListView.kitchenInfo = _kitchenInfo;
    _dishListView.order = _order;
    
    float offsetX = 15;
    WERoundTextListView *featureListView = [WERoundTextListView new];
    featureListView.textFont = [UIFont systemFontOfSize:13];
    featureListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    featureListView.cornerRadius = 6;
    featureListView.onlyBorder = NO;
    featureListView.maxWidth = [WEUtil getScreenWidth] - 2*offsetX;
    featureListView.lineSpace = 10;
    featureListView.itemSpace = 10;
    featureListView.textBgColor = [UIColor lightGrayColor];
    featureListView.allowMultiSelect = YES;
    featureListView.selectedBgColor = DARK_ORANGE_COLOR;
    //featureListView.showMoreButton = YES;
    //[featureListView setStringArray: @[@"超赞", @"分量足", @"味道正", @"有赠品", @"口味偏淡", @"好吃",
     //                                  @"有赠品", @"有赠品", @"有赠品", @"有赠品", @"有赠品", @"好吃"]];
    //featureListView.backgroundColor = [UIColor blueColor];
    _quickCommentList = featureListView;
    WEGlobalData *global = [WEGlobalData sharedInstance];
    if (global.orderCommentArray.count) {
        [featureListView setStringArray:global.orderCommentArray];
    } else {
        [self loadTagList];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[WEMainTabBarController sharedInstance] setTabBarHidden:YES animated:NO];
    [self addRightNavButton:@"提交评论" image:nil target:self selector:@selector(rightButtonTapped:)];
}

- (void)loadTagList
{
    [WENetUtil GetTagListForOrderCommentWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        WEGlobalData *global = [WEGlobalData sharedInstance];
        global.orderCommentArray = [dict objectForKey:@"TagList"];
        [_quickCommentList setStringArray:global.orderCommentArray];
        [_commentTableView reloadData];
        [self updateTableHeight];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        
    }];
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTableHeight];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rightButtonTapped:(UIButton *)button
{
    NSString *positive;
    if (_radioIndex == 0) {
        positive = WEPositive_POSITIVE;
    } else if (_radioIndex == 1) {
        positive = WEPositive_NEUTRAL;
    } else {
        positive = WEPositive_NEGATIVE;
    }
    
    NSSet *set = _quickCommentList.selectedSet;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:set.count];
    WEGlobalData *global = [WEGlobalData sharedInstance];
    for(NSString *key in set) {
        NSString *text = [global.orderCommentArray objectAtIndex:key.integerValue];
        [array addObject:text];
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在添加评论，请稍后...";
    [hud show:YES];
    [WENetUtil AddCommentWithOrderId:_order.Id
                            Positive:positive
                             Message:_commentContent
                             TagList:array
                             success:^(NSURLSessionDataTask *task, id responseObject) {
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
                                 hud.labelText = @"添加成功";
                                 [hud hide:YES afterDelay:1.0];
                                 hud.delegate = self;
                                 
                             }
                             failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                 NSLog(@"errorMsg %@", errorMsg);
                                 hud.labelText = errorMsg;
                                 [hud hide:YES afterDelay:1.5];
                             }];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateTableHeight
{
    _commentTableViewHeightConstraint.equalTo(_commentTableView.contentSize.height);
    _dishListViewHeightConstraint.equalTo( _dishListView.tableView.contentSize.height );
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor lightGrayColor];
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 40);
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(20, 0, 200, 40);
    [bg addSubview:label];
    if (section == 0) {
        label.text = @"总评";
    } else if (section == 1) {
        label.text = @"留言";
    } else {
        label.text = @"快评";
    }
    return bg;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    
    if (indexPath.section == 0) {
        if (!_checkGroup) {
            TNImageRadioButtonData *data1 = [TNImageRadioButtonData new];
            data1.labelFont = [UIFont systemFontOfSize:13];
            data1.labelActiveColor = [UIColor lightGrayColor];
            data1.labelPassiveColor = [UIColor lightGrayColor];
            data1.labelText = @"好评";
            data1.identifier = @"0";
            data1.selected = YES;
            data1.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
            data1.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
            data1.labelOffset = 5;
            
            TNImageRadioButtonData *data2 = [TNImageRadioButtonData new];
            data2.labelFont = [UIFont systemFontOfSize:13];
            data2.labelActiveColor = [UIColor lightGrayColor];
            data2.labelPassiveColor = [UIColor lightGrayColor];
            data2.labelText = @"中评";
            data2.identifier = @"1";
            data2.selected = NO;
            data2.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
            data2.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
            data2.labelOffset = 5;
            
            TNImageRadioButtonData *data3 = [TNImageRadioButtonData new];
            data3.labelFont = [UIFont systemFontOfSize:13];
            data3.labelActiveColor = [UIColor lightGrayColor];
            data3.labelPassiveColor = [UIColor lightGrayColor];
            data3.labelText = @"差评";
            data3.identifier = @"2";
            data3.selected = NO;
            data3.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
            data3.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
            data3.labelOffset = 5;
            
            TNRadioButtonGroup *group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[data1, data2, data3] layout:TNRadioButtonGroupLayoutHorizontal];
            group.marginBetweenItems = 30;
            group.identifier = @"group";
            [group create];
            group.position = CGPointMake(20, 15);
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentCheckGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:group];
            [group update];
            _checkGroup = group;
        }
        [superView addSubview:_checkGroup];
    
    } else if (indexPath.section == 1) {
        UITextView *textView = [UITextView new];
        textView.textColor = UICOLOR(68,68,68);
        textView.scrollEnabled = NO;
        textView.delegate = self;
        [superView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(5);
            make.left.equalTo(superView.left).offset(20);
            make.right.equalTo(superView.right);
            make.bottom.equalTo(superView.bottom).offset(-5);
        }];
       
        if (!_commentContent.length) {
            textView.text = @"未填写";
        }
        _commentTextView = textView;
        if (_commentContent.length) {
            _commentTextView.text = _commentContent;
        }
        
    } else {
        WEGlobalData *global = [WEGlobalData sharedInstance];
        if (global.orderCommentArray.count) {
            float offsetX = 20;
            [superView addSubview:_quickCommentList];
            [_quickCommentList makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView.left).offset(offsetX);
                make.width.equalTo([_quickCommentList getWidth]);
                make.top.equalTo(superView.top).offset(10);
                make.height.equalTo([_quickCommentList getHeight]);
            }];
            
        }
    }

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        if (_commentTextHeight) {
            return _commentTextHeight + 5 + 5;
        } else {
            return 44;
        }
    } else {
        return [_quickCommentList getHeight] + 20;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)commentCheckGroupUpdated:(NSNotification *)notification {
    NSLog(@"group updated to %@", _checkGroup.selectedRadioButton.data.identifier);
    _radioIndex = _checkGroup.selectedRadioButton.data.identifier.integerValue;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!_placeHolder && [textView.text isEqualToString:@"未填写"]) {
        _placeHolder = YES;
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _commentContent = textView.text;
    float width = [WEUtil getScreenWidth] - 20;
    //_commentTextHeight = [WEUtil sizeForTitle:textView.text font:textView.font maxWidth:width].height;
    _commentTextHeight = [textView sizeThatFits:CGSizeMake(width, 1000*10)].height;
    //NSLog(@"%f %f", _commentTextHeight, h);
    [_commentTableView beginUpdates];
    [_commentTableView endUpdates];
    [self performSelectorOnMainThread:@selector(updateTableHeight) withObject:nil waitUntilDone:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

@end
