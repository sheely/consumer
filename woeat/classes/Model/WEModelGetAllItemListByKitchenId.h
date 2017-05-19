//
//  WEModelGetAllItemListByKitchenId.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetAllItemListByKitchenIdItemList
@end

@interface WEModelGetAllItemListByKitchenIdItemList : JSONModel
@property(nonatomic, assign) BOOL NeedPreorder;
@property(nonatomic, strong) NSString<Optional> *KitchenId;
@property(nonatomic, assign) int TotalPositiveVotes;
@property(nonatomic, assign) int UserRating;
@property(nonatomic, assign) BOOL IsFeatured;
@property(nonatomic, assign) int TotalNeutralVotes;
@property(nonatomic, assign) int TotalUserFavourites;
@property(nonatomic, assign) int TomorrowAvailability;
@property(nonatomic, assign) BOOL CanPreorder;
@property(nonatomic, assign) int TodayAvailability;
@property(nonatomic, assign) int SoldUnitsLifeLong;
@property(nonatomic, strong) NSString<Optional> *PortraitImageId;
@property(nonatomic, strong) NSString<Optional> *Description;
@property(nonatomic, strong) NSString<Optional> *PortraitImageUrl;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, assign) double UnitPrice;
@property(nonatomic, assign) BOOL IsActive;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, assign) int InternalRating;
@property(nonatomic, assign) int TotalNegativeVotes;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, assign) int SoldUnitsMonthToDate;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, strong) NSString<Optional> *CuisineId;
@property(nonatomic, assign) int DailyAvailability;
@end

@interface WEModelGetAllItemListByKitchenId : JSONModel
@property(nonatomic, strong) NSString<Optional> *PageFilter;
@property(nonatomic, strong) NSArray<WEModelGetAllItemListByKitchenIdItemList> *ItemList;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ModelFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end

