//
//  WEModelOrder.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelOrderLines
@end

@interface WEModelOrderLines : JSONModel
@property(nonatomic, assign) int Quantity;
@property(nonatomic, strong) NSString<Optional> *ItemId;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *SalesOrderId;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, strong) NSString<Optional> *UserCouponId;
@property(nonatomic, assign) double UnitPrice;
@property(nonatomic, strong) NSString<Optional> *LineType;
@property(nonatomic, assign) double LineTotalValue;
@property(nonatomic, strong) NSString<Optional> *Reference;
@end

@interface WEModelOrder : JSONModel
@property(nonatomic, strong) NSString<Optional> *OrderStatus;
@property(nonatomic, assign) BOOL IsCommented;
@property(nonatomic, strong) NSString<Optional> *DispatchToCity;
@property(nonatomic, strong) NSString<Optional> *RequiredArrivalTime;
@property(nonatomic, strong) NSString<Optional> *RejectReason;
@property(nonatomic, strong) NSString<Optional> *TimeDispatched;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressLine3;
@property(nonatomic, strong) NSString<Optional> *Message;
@property(nonatomic, strong) NSString<Optional> *DispatchToState;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressId;
@property(nonatomic, strong) NSString<Optional> *TimeReceived;
@property(nonatomic, strong) NSString<Optional> *KitchenId;
@property(nonatomic, strong) NSString<Optional> *ContactNumber;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *DispatchToPostcode;
@property(nonatomic, assign) int DiscountValue;
@property(nonatomic, assign) BOOL IsSubmitted;
@property(nonatomic, assign) BOOL IsReceived;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressLine2;
@property(nonatomic, assign) BOOL IsFullyPaid;
@property(nonatomic, assign) int DispatchToLongitude;
@property(nonatomic, assign) double PayableValue;
@property(nonatomic, strong) NSString<Optional> *TimeKitchenResponded;
@property(nonatomic, assign) BOOL IsReadyForDispatch;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *ContactName;
@property(nonatomic, assign) int DispatchToLatitude;
@property(nonatomic, strong) NSString<Optional> *DispatchToCountry;
@property(nonatomic, strong) NSString<Optional> *TimeReadyForDispatch;
@property(nonatomic, assign) BOOL IsRejected;
@property(nonatomic, strong) NSString<Optional> *DispatchToAddressLine1;
@property(nonatomic, assign) BOOL IsDispatched;
@property(nonatomic, strong) NSArray<WEModelOrderLines> *Lines;
@property(nonatomic, assign) double TotalValue;
@property(nonatomic, assign) BOOL IsPartiallyPaid;
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, strong) NSString<Optional> *TimeAdminResponded;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *DispatchMethod;
@property(nonatomic, assign) BOOL IsAccepted;
@end

