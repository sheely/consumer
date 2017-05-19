//
//  WESearchCityViewController.m
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WESearchCityViewController.h"
#import "WESearchBar.h"
#import "WECity.h"
#import "WEState.h"
#import "WECityManager.h"
#import "WESearchCityCell.h"
#import "WEUtil.h"

@interface WESearchCityViewController ()
{
    WESearchBar *_searchBar;
    UITableView *_tableView;
}
@end

@implementation WESearchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    if (_stateId) {
        self.title = @"选择城市";
    } else {
        self.title = @"选择州";
    }
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    WESearchBar *searchBar = [WESearchBar new];
    searchBar.cancelButtonHidden = YES;
    if (_stateId) {
        searchBar.textField.placeholder = @"请输入城市名";
    } else {
        searchBar.textField.placeholder = @"请输入州名";
    }
    searchBar.searchDelegate = self;
    [self.view addSubview:searchBar];
    [searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.height.equalTo(45);
    }];
    _searchBar = searchBar;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    tableView.showsVerticalScrollIndicator = YES;
    [tableView registerClass:[WESearchCityCell class] forCellReuseIdentifier:@"WESearchCityCell"];
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.mas_bottom).offset(5);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_stateId) {
        NSString *search = _searchBar.textField.text;
        if (!search.length) {
            search = nil;
        }
        int count = [[WECityManager sharedInstance] getCityCountWithStateId:_stateId query:search];
        return count;
    
    } else {
        NSString *search = _searchBar.textField.text;
        if (!search.length) {
            search = nil;
        }
        NSArray *array = [[WECityManager sharedInstance] getAllStatesWithQuery:search];
        return array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"WESearchCityCell";
    WESearchCityCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[WESearchCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] ;
    }
    if (_stateId) {
        NSString *search = _searchBar.textField.text;
        if (!search.length) {
            search = nil;
        }
        WECity *city = [[WECityManager sharedInstance] getCityWithStateId:_stateId query:search atIndex:indexPath.row];
        //cell.leftLabel.text = city.Name;
        //cell.rightLabel.text = city.County;
        NSAttributedString *leftAttr = [WEUtil getAttributeStringWithNormalFont:cell.leftLabel.font
                                                                normalColor:[UIColor blackColor]
                                                               normalString:city.Name
                                                              highlightFont:cell.leftLabel.font
                                                             highlightColor:[UIColor redColor]
                                                            highlightString:search];
        cell.leftLabel.attributedText = leftAttr;
        
        NSAttributedString *rightAttr = [WEUtil getAttributeStringWithNormalFont:cell.rightLabel.font
                                                                    normalColor:UICOLOR(68, 68, 68)
                                                                   normalString:city.County
                                                                  highlightFont:cell.rightLabel.font
                                                                 highlightColor:[UIColor redColor]
                                                                highlightString:search];
        cell.rightLabel.attributedText = rightAttr;
        return cell;
        
    } else {
        NSString *search = _searchBar.textField.text;
        if (!search.length) {
            search = nil;
        }
        NSArray *array = [[WECityManager sharedInstance] getAllStatesWithQuery:search];
        WEState *state = [array objectAtIndex:indexPath.row];
        //cell.leftLabel.text = state.Name;
        //cell.rightLabel.text = state.Code;
        NSAttributedString *leftAttr = [WEUtil getAttributeStringWithNormalFont:cell.leftLabel.font
                                                                    normalColor:[UIColor blackColor]
                                                                   normalString:state.Name
                                                                  highlightFont:cell.leftLabel.font
                                                                 highlightColor:[UIColor redColor]
                                                                highlightString:search];
        cell.leftLabel.attributedText = leftAttr;
        
        NSAttributedString *rightAttr = [WEUtil getAttributeStringWithNormalFont:cell.rightLabel.font
                                                                     normalColor:UICOLOR(68, 68, 68)
                                                                    normalString:state.Code
                                                                   highlightFont:cell.rightLabel.font
                                                                  highlightColor:[UIColor redColor]
                                                                 highlightString:search];
        cell.rightLabel.attributedText = rightAttr;

        return cell;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_stateId) {
        if ([_searchDelegate respondsToSelector:@selector(userSelecteCity:)]) {
            NSString *search = _searchBar.textField.text;
            if (!search.length) {
                search = nil;
            }
            WECity *city = [[WECityManager sharedInstance] getCityWithStateId:_stateId query:search atIndex:indexPath.row];
            [_searchDelegate userSelecteCity:city];
        }
    
    } else {
        if ([_searchDelegate respondsToSelector:@selector(userSelecteState:)]) {
            NSString *search = _searchBar.textField.text;
            if (!search.length) {
                search = nil;
            }
            NSArray *array = [[WECityManager sharedInstance] getAllStatesWithQuery:search];
            WEState *state = [array objectAtIndex:indexPath.row];
            [_searchDelegate userSelecteState:state];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)searchBarCancelButtonClicked:(WESearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked");
//    upViewTopConstraint.offset(0);
//    [searchBar.textField resignFirstResponder];
//    searchBar.textField.text = @"";
//    searchBar.cancelButtonHidden = YES;
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [_tableView reloadData];
//    }];
}
- (void)searchBarSearchButtonClicked:(WESearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
}
- (BOOL)searchBarShouldBeginEditing:(WESearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    return YES;
}
- (void)searchBarTextDidBeginEditing:(WESearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
//    upViewTopConstraint.offset(-135);
//    searchBar.cancelButtonHidden = NO;
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        
//    }];
    
}
- (void)searchBarTextDidEndEditing:(WESearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
    
    
}

- (void)searchBar:(WESearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange");
    if (!searchBar.textField.isFirstResponder) {
        return;
    }
    [_tableView reloadData];
}

@end
