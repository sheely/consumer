//
//  WENetUtil.h
//  woeat
//
//  Created by liubin on 16/10/24.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEPositive_POSITIVE   @"POSITIVE"
#define WEPositive_NEUTRAL    @"NEUTRAL"
#define WEPositive_NEGATIVE   @"NEGATIVE"


@interface WENetUtil : NSObject

+ (void)setTokenString:(NSString *)tokenString;

+ (void)sendSecurityCodeWithPhoneNumber:(NSString *)phoneNumber
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


+ (void)userLoginWithPhoneNumber:(NSString *)phoneNumber
                     securityCode :(NSString *)securityCode
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//首页上方轮播图
+ (void)getListForConsumerHomeSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//厨房列表
+ (void)getListWithSessionId:(NSString *)SessionId
                  PageNumber:(int)PageNumber
                        Mode:(NSString *)Mode
                    Latitude:(NSString *)Latitude
                   Longitude:(NSString *)Longitude
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//厨房详情
+ (void)GetConsumerKitchenWithKitchenId:(NSString *)KitchenId
                               Latitude:(NSString *)Latitude
                              Longitude:(NSString *)Longitude
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//引导页
+ (void)getListForConsumerSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;



//收藏厨房
+ (void)UserFavouriteAddKitchenWithKitchenId:(NSString *)KitchenId
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//取消收藏厨房
+ (void)UserFavouriteRemoveKitchenWithKitchenId:(NSString *)KitchenId
                                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//厨房 tag list
+ (void)GetTagListForKitchenWithKitchenId:(NSString *)KitchenId
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//返回用户评论订单时用到的标签列表
+ (void)GetTagListForOrderCommentWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//今日菜品
+ (void)GetItemTodayWithKitchenId:(NSString *)KitchenId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//预订明日
+ (void)GetItemTomorrowWithKitchenId:(NSString *)KitchenId
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//下订单
+ (void)SubmitOrderWithKitchenId:(NSString *)KitchenId
                         isToday:(BOOL)isToday
                     itemIdArray:(NSArray *)itemIdArray
                  unitPriceArray:(NSArray *)unitPriceArray
                   quantityArray:(NSArray *)quantityArray
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//获取所有可用优惠券
+ (void)GetMyRedeemableCouponWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;
//获取所有优惠券,包括可用的和已用过的
+ (void)GetMyCouponListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;
//添加优惠券。用户获得优惠券或获知优惠券代码后，调用此接口添加优惠券到自己个人名下
+ (void)ClaimCouponWithCouponCode:(NSString *)CouponCode
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;
//添加优惠券。用户获得优惠券或获知优惠券代码后，调用此接口添加优惠券到自己个人名下
+ (void)GetCouponByIdWithCouponId:(NSString *)CouponId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//根据Id获取用户已添加的优惠券详情
+ (void)GetUserCouponWithCouponId:(NSString *)CouponId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//向指定的订单添加优惠券
+ (void)AddCouponToOrderWithCouponId:(NSString *)CouponId
                             OrderId:(NSString *)OrderId
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//提交详细订单信息
+ (void)UpdateOrderForCheckoutWithOrderId:(NSString *)OrderId
                           DispatchMethod:(NSString *)DispatchMethod
                      RequiredArrivalTime:(NSString *)RequiredArrivalTime
                                  Message:(NSString *)Message
                             UserCouponId:(NSString *)UserCouponId
                   DispatchToAddressLine1:(NSString *)DispatchToAddressLine1
                   DispatchToAddressLine2:(NSString *)DispatchToAddressLine2
                   DispatchToAddressLine3:(NSString *)DispatchToAddressLine3
                           DispatchToCity:(NSString *)DispatchToCity
                          DispatchToState:(NSString *)DispatchToState
                        DispatchToCountry:(NSString *)DispatchToCountry
                       DispatchToPostcode:(NSString *)DispatchToPostcode
                       DispatchToLatitude:(NSString *)DispatchToLatitude
                      DispatchToLongitude:(NSString *)DispatchToLongitude
                    DispatchToContactName:(NSString *)DispatchToContactName
                    DispatchToPhoneNumber:(NSString *)DispatchToPhoneNumber
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//获取当前用户的余额
+ (void)GetMyBalanceWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//提交详细订单信息
+ (void)CheckoutUsingBankCardWithOrderId:(NSString *)OrderId
                                CardType:(NSString *)CardType
                          CardHolderName:(NSString *)CardHolderName
                              CardNumber:(NSString *)CardNumber
                                ExpiryMM:(NSString *)ExpiryMM
                                ExpiryYY:(NSString *)ExpiryYY
                                     Cvn:(NSString *)Cvn
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//用户向自己的账户充值
+ (void)RechargeWithCardType:(NSString *)CardType
              CardHolderName:(NSString *)CardHolderName
                  CardNumber:(NSString *)CardNumber
                    ExpiryMM:(NSString *)ExpiryMM
                    ExpiryYY:(NSString *)ExpiryYY
                         CVN:(NSString *)CVN
                       Value:(NSString *)Value
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//支付订单(使用用户充值)
+ (void)CheckoutUsingBalanceWithOrderId:(NSString *)OrderId
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//进行中的订单
+ (void)GetMyOrderListInProgressWithPageIndex:(int)PageIndex
                                     Pagesize:(int)Pagesize
                                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//待评论的订单
+ (void)GetMyOrderListToCommentWithPageIndex:(int)PageIndex
                                    Pagesize:(int)Pagesize
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//已完成的订单
+ (void)GetMyOrderListCompletedWithPageIndex:(int)PageIndex
                                    Pagesize:(int)Pagesize
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//添加评论
+ (void)AddCommentWithOrderId:(NSString *)OrderId
                     Positive:(NSString *)Positive
                      Message:(NSString *)Message
                      TagList:(NSArray *)TagList
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//根据指定条件来搜索评论记录
+ (void)GetCommentListWithPageIndex:(int)PageIndex
                           Pagesize:(int)Pagesize
                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//回复评论,仅测试
+ (void)ReplyCommentWithParentCommentId:(NSString *)ParentCommentId
                                Message:(NSString *)Message
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//搜索厨房评论
+ (void)GetCommentListOpenWithPageIndex:(int)PageIndex
                               Pagesize:(int)Pagesize
                              kitchenId:(NSString *)kitchenId
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//上传图片至服务器
+ (void)UploadWithImage:(UIImage *)image
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//更新用户头像
+ (void)UpdateUserImageWithImageId:(NSString *)ImageId
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//更新用户信息
+ (void)UpdateUserDetailsWithDisplayName:(NSString *)DisplayName
                                  isMale:(BOOL)isMale
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//获取当前用户的详情
+ (void)GetMyDetailsSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//注册厨房信息
+ (void)RegisterWithName:(NSString *)Name
            ChefUsername:(NSString *)ChefUsername
                  isMale:(BOOL)isMale
            AddressLine1:(NSString *)AddressLine1
                    City:(NSString *)City
                   State:(NSString *)State
                Postcode:(NSString *)Postcode
               Longitude:(NSString *)Longitude
                Latitude:(NSString *)Latitude
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//为当前用户添加新的送餐地址
+ (void)AddDeliveryAddressWithContactName:(NSString *)ContactName
                              PhoneNumber:(NSString *)PhoneNumber
                             DisplayOrder:(int)DisplayOrder
                             AddressLine1:(NSString *)AddressLine1
                                     City:(NSString *)City
                                    State:(NSString *)State
                                 Postcode:(NSString *)Postcode
                                Longitude:(NSString *)Longitude
                                 Latitude:(NSString *)Latitude
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//移除送餐地址
+ (void)DeleteDeliveryAddressWithAddressId:(NSString *)AddressId
                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//获取当前用户的送餐地址列表
+ (void)GetMyDeliveryAddressListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;
//根据关键字搜索厨房和菜品
+ (void)WildSearchWithKeywords:(NSString *)Keywords
                     PageIndex:(int)PageIndex
                     Longitude:(NSString *)Longitude
                      Latitude:(NSString *)Latitude
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//根据经纬度获取地址信息
+ (void)GetAddressFromLatLngWitLat:(NSString *)Lat
                               Lng:(NSString *)Lng
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//根据指定ItemId来获取专门针对饭友端返回的菜品信息
+ (void)GetConsumerItemWithItemId:(NSString *)ItemId
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//获取当前家厨用户的菜品列表
+ (void)GetAllItemListByKitchenIdWithKitchenId:(NSString *)KitchenId
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//厨房tag
+ (void)GetCommentTagListOfKitchenWithKitchenId:(NSString *)KitchenId
                                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//供饭友端使用，使用用户已保存的银行卡向自己的账户充值
+ (void)RechargeBySavedCardWithCardId:(NSString *)CardId
                                Value:(NSString *)Value
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//获取当前用户的所有银行卡
+ (void)GetMyCardListWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//添加银行卡
+ (void)AddCardWithName:(NSString *)Name
             CardNumber:(NSString *)CardNumber
            ExpiryMonth:(NSString *)ExpiryMonth
             ExpiryYear:(NSString *)ExpiryYear
                    Cvn:(NSString *)Cvn
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//删除银行卡
+ (void)DeleteCardWithBankCardId:(NSString *)BankCardId
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//设置默认银行卡
+ (void)SetDefaultCardWithBankCardId:(NSString *)BankCardId
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;
//根据指定cardId来获取银行卡信息
+ (void)GetCardWithcardId:(NSString *)cardId
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;

//更新银行卡
+ (void)UpdateCardWithBankCardId:(NSString *)BankCardId
                            Name:(NSString *)Name
                     ExpiryMonth:(NSString *)ExpiryMonth
                      ExpiryYear:(NSString *)ExpiryYear
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;


//供饭友端调用。支付订单(使用已保存的银行卡支付)
+ (void)CheckoutUsingSavedBankCardWithBankCardId:(NSString *)BankCardId
                                         OrderId:(NSString *)OrderId
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSString *errorMsg))failure;
@end
