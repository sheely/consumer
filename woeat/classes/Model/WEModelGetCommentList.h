//
//  WEModelGetCommentList.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetCommentListCommentList
@end

@interface WEModelGetCommentListCommentListReply : JSONModel
@property(nonatomic, strong) NSString<Optional> *ParentCommentId;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitId;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *ByUserId;
@property(nonatomic, strong) NSString<Optional> *Reply;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *SalesOrderDispatchMethod;
//@property(nonatomic, strong) NSArray<NSString<Optional> *> *TagList;
@property(nonatomic, strong) NSString<Optional> *KitchenName;
@property(nonatomic, assign) int SalesOrderTotalValue;
@property(nonatomic, strong) NSString<Optional> *UserPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *Positive;
@property(nonatomic, strong) NSString<Optional> *Message;
@property(nonatomic, strong) NSString<Optional> *ObjectType;
@property(nonatomic, strong) NSString<Optional> *ObjectTimeCreated;
@property(nonatomic, strong) NSString<Optional> *UserPortraitId;
@property(nonatomic, strong) NSString<Optional> *ObjectId;
@end

@interface WEModelGetCommentListPageFilter : JSONModel
@property(nonatomic, assign) int PageIndex;
@property(nonatomic, strong) NSString<Optional> *SortBy;
@property(nonatomic, assign) int PageSize;
@property(nonatomic, strong) NSString<Optional> *SortDir;
@property(nonatomic, assign) int TotalRecords;
@property(nonatomic, assign) int TotalPages;
@end

@interface WEModelGetCommentListCommentList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ParentCommentId;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitId;
@property(nonatomic, strong) NSString<Optional> *UserDisplayName;
@property(nonatomic, strong) NSString<Optional> *KitchenPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *ByUserId;
@property(nonatomic, strong) WEModelGetCommentListCommentListReply<Optional> *Reply;
@property(nonatomic, strong) NSString<Optional> *TimeCreated;
@property(nonatomic, strong) NSString<Optional> *SalesOrderDispatchMethod;
@property(nonatomic, strong) NSString<Optional> *KitchenName;
@property(nonatomic, assign) double SalesOrderTotalValue;
@property(nonatomic, strong) NSString<Optional> *UserPortraitUrl;
@property(nonatomic, strong) NSString<Optional> *Positive;
@property(nonatomic, strong) NSString<Optional> *Message;
@property(nonatomic, strong) NSString<Optional> *ObjectType;
@property(nonatomic, strong) NSString<Optional> *ObjectTimeCreated;
@property(nonatomic, strong) NSString<Optional> *UserPortraitId;
@property(nonatomic, strong) NSString<Optional> *ObjectId;
@property(nonatomic, strong) NSArray<NSString<Optional> *> *TagList;
@end

@interface WEModelGetCommentList : JSONModel
@property(nonatomic, strong) WEModelGetCommentListPageFilter<Optional> *PageFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSArray<WEModelGetCommentListCommentList> *CommentList;
@property(nonatomic, strong) NSString<Optional> *ModelFilter;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end

