//
//  WEModelGetList.h
//  woeat
//
//  Created by liubin on 16/11/4.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetListKitchens
@end


@interface WEModelGetListKitchens : JSONModel
@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *SessionId;
@property(nonatomic, strong) NSString *DisplayOrder;
@property(nonatomic, strong) NSString *KitchenId;
@property(nonatomic, strong) NSString *DistanceInKm;
@property(nonatomic, strong) NSString *Name;
@property(nonatomic, strong) NSString *CustomerRating;
@property(nonatomic, strong) NSString *PortraitImageId;
@property(nonatomic, strong) NSString *IsCertified;
@property(nonatomic, strong) NSString *AddressLine1;
@property(nonatomic, strong) NSString *AddressLine2;
@property(nonatomic, strong) NSString *AddressLine3;
@property(nonatomic, strong) NSString *City;
@property(nonatomic, strong) NSString *State;
@property(nonatomic, strong) NSString *Postcode;
@property(nonatomic, strong) NSNumber *IsMyFavourite;
@property(nonatomic, strong) NSString *PortraitImageUrl;
@property(nonatomic, strong) NSNumber *MonthlyAverageOrderValue;
@property(nonatomic, strong) NSNumber *MonthlyOrderCount;
@property(nonatomic, strong) NSString *FormattedDistanceString;
@end


@interface WEModelGetList : JSONModel
@property(nonatomic, strong) NSString *SessionId;
@property(nonatomic, assign) int PageNumber;
@property(nonatomic, assign) int PageCount;
@property(nonatomic, strong) NSArray<WEModelGetListKitchens> *Kitchens;
@end
