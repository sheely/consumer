//
//  WESearchBar.h
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WESearchBar;
@protocol WESearchBarDelegate <NSObject>

@optional
- (void)searchBarCancelButtonClicked:(WESearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(WESearchBar *)searchBar;

- (BOOL)searchBarShouldBeginEditing:(WESearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(WESearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(WESearchBar *)searchBar;

- (void)searchBar:(WESearchBar *)searchBar textDidChange:(NSString *)searchText;
@end


@interface WESearchBar : UIView

@property (nonatomic, assign) BOOL cancelButtonHidden;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) id <WESearchBarDelegate> searchDelegate;
@end
