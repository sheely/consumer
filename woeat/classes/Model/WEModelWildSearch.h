//
//  WEModelWildSearch.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelWildSearchKitchenList
@end

@protocol WEModelWildSearchKitchenListItems
@end

@interface WEModelWildSearchKitchenListItems : JSONModel
@property(nonatomic, assign) double UnitPrice;
@property(nonatomic, strong) NSString<Optional> *ItemId;
@property(nonatomic, strong) NSString<Optional> *ItemName;
@end

@interface WEModelWildSearchKitchenList : JSONModel
@property(nonatomic, strong) NSString<Optional> *KitchenId;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitImageId;
@property(nonatomic, strong) NSString<Optional> *KitchenName;
@property(nonatomic, strong) NSString<Optional> *DistanceDescription;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitImageUrl;
@property(nonatomic, strong) NSArray<WEModelWildSearchKitchenListItems> *Items;
@property(nonatomic, assign) int CustomerRating;
@end

@interface WEModelWildSearch : JSONModel
@property(nonatomic, strong) NSArray<WEModelWildSearchKitchenList> *KitchenList;
@property(nonatomic, assign) int PageNumber;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) int PageSize;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, assign) int PageCount;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end

