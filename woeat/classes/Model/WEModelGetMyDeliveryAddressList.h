//
//  WEModelGetMyDeliveryAddressList.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetMyDeliveryAddressListAddressList
@end

@interface WEModelGetMyDeliveryAddressListAddressList : JSONModel
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, assign) double Latitude;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *ContactName;
@property(nonatomic, assign) double Longitude;
@property(nonatomic, strong) NSString<Optional> *City;
@property(nonatomic, strong) NSString<Optional> *Postcode;
@property(nonatomic, strong) NSString<Optional> *Country;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, strong) NSString<Optional> *State;
@property(nonatomic, strong) NSString<Optional> *AddressLine1;
@property(nonatomic, strong) NSString<Optional> *PhoneNumber;
@property(nonatomic, strong) NSString<Optional> *AddressLine2;
@property(nonatomic, strong) NSString<Optional> *AddressLine3;
@property(nonatomic, strong) NSString<Optional> *ValidationStatus;
@end

@interface WEModelGetMyDeliveryAddressList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSArray<WEModelGetMyDeliveryAddressListAddressList> *AddressList;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end

