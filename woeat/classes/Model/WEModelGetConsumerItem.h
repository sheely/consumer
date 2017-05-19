//
//  WEModelGetConsumerItem.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@interface WEModelGetConsumerItemItem : JSONModel
@property(nonatomic, assign) int TotalPositiveVotes;
@property(nonatomic, strong) NSString<Optional> *KitchenId;
@property(nonatomic, assign) int TotalNeutralVotes;
@property(nonatomic, assign) BOOL IsFeatured;
@property(nonatomic, assign) int UserRating;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, assign) int TotalUserFavourites;
@property(nonatomic, assign) BOOL CanPreorder;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *PortraitImageId;
@property(nonatomic, strong) NSString<Optional> *Description;
@property(nonatomic, strong) NSString<Optional> *PortraitImageUrl;
@property(nonatomic, assign) int SoldQtyLifeLong;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, assign) double UnitPrice;
@property(nonatomic, assign) BOOL IsActive;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, assign) int TotalNegativeVotes;
@property(nonatomic, assign) int SoldQtyMonthToDate;
@property(nonatomic, assign) int CurrentAvailability;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, assign) BOOL NeedPreorder;
@property(nonatomic, assign) int DailyAvailability;
@end

@interface WEModelGetConsumerItem : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) WEModelGetConsumerItemItem<Optional> *Item;
@end

