//
//  WEModelGetMyOrderList.h
//  woeat
//
//  Created by liubin on 16/12/27.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"
#import "WEModelOrder.h"

@protocol WEModelOrder
@end

@interface WEModelGetMyOrderListPageFilter : JSONModel
@property(nonatomic, assign) int PageIndex;
@property(nonatomic, assign) int PageSize;
@property(nonatomic, assign) int TotalRecords;
@property(nonatomic, assign) int TotalPages;

@end


@interface WEModelGetMyOrderList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) WEModelGetMyOrderListPageFilter *PageFilter;
@property(nonatomic, strong) NSArray<WEModelOrder> *OrderList;
@end
