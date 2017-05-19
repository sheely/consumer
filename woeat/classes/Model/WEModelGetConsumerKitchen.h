//
//  WEModelGetConsumerKitchen.h
//  woeat
//
//  Created by liubin on 16/11/15.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"


@interface WEModelGetConsumerKitchen : JSONModel
@property(nonatomic, strong) NSString *AddressLine1;
@property(nonatomic, strong) NSString *AddressLine2;
@property(nonatomic, strong) NSString *BroadcastMessage;
@property(nonatomic, assign) int CanDeliver;
@property(nonatomic, assign) int CanPickup;
@property(nonatomic, assign) int ChefImageId;
@property(nonatomic, strong) NSString *ChefImageUrl;
@property(nonatomic, strong) NSString *ChefName;
@property(nonatomic, strong) NSString *City;
@property(nonatomic, assign) float CustomerRating;
@property(nonatomic, strong) NSString *DistanceInKm;
@property(nonatomic, strong) NSString *FormattedDistanceString;
@property(nonatomic, strong) NSString *Id;
@property(nonatomic, assign) int IsCertified;
@property(nonatomic, assign) int IsMyFavourite;
@property(nonatomic, assign) int IsOpen;
@property(nonatomic, strong) NSString *KitchenStory;
@property(nonatomic, strong) NSString *Latitude;
@property(nonatomic, strong) NSString *Longitude;
@property(nonatomic, strong) NSString *Name;
@property(nonatomic, strong) NSString *PortraitImageId;
@property(nonatomic, strong) NSString *PortraitImageUrl;
@property(nonatomic, strong) NSString *Postcode;
@property(nonatomic, strong) NSString *State;
@property(nonatomic, strong) NSArray<Optional> *Images;
@end
