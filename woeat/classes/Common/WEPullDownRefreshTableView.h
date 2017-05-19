//
//  WEPullDownRefreshTableView.h
//  woeat
//
//  Created by liubin on 16/11/4.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEPullDownRefreshTableView : UITableView

- (void)pullDownSetRefreshTarget:(id)target headerSel:(SEL)headerSel footerSel:(SEL)footerSel isAllLoadedSel:(SEL)isAllLoadedSel;
- (void)pullDownHeaderBeginRefresh;
- (void)clearAllLoadedState;
- (void)setAllLoadedState;


@end
