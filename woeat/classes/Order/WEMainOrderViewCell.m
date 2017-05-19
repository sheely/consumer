//
//  WEMainOrderViewCell.m
//  woeat
//
//  Created by liubin on 16/11/16.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEMainOrderViewCell.h"
#import "UIImageView+WebCache.h"
#import "WEUtil.h"
#import "WERightImageButton.h"
#import "WEOrderAddCommentViewController.h"
#import "WEOrderPayViewController.h"
#import "WEOrderDetailViewController.h"
#import "WEModelGetMyOrderList.h"
#import "WEKitchenCache.h"
#import "WENetUtil.h"
#import "WEModelGetConsumerKitchen.h"
#import "WEOrderStatus.h"
#import "WEModelOrder.h"
#import "WEOrderConfirmViewController.h"

#define CELL_TOP  30
#define CELL_BOTTOM  10


@interface WEMainOrderViewCell()
{
    UILabel *_orderId;
    UILabel *_orderStatus;
    UILabel *_orderDate;
    UIImageView *_imgView;
    UILabel *_kitchenName;
    UILabel *_diliver;
    UILabel *_price;
    WERightImageButton *_detailButton;
    WERightImageButton *_payButton;
    WERightImageButton *_commentButton;
    UIView *_commentView;
    WEModelOrder* _order;
}

@end

@implementation WEMainOrderViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    float offsetX = 15;
    UILabel *orderId = [UILabel new];
    orderId.numberOfLines = 1;
    orderId.textAlignment = NSTextAlignmentLeft;
    orderId.font = [UIFont systemFontOfSize:13];
    orderId.textColor = [UIColor blackColor];
    //orderId.text = @"订单号 102226";
    [superView addSubview:orderId];
    [orderId sizeToFit];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(CELL_TOP);
    }];
    _orderId = orderId;

    UILabel *orderStatus = [UILabel new];
    orderStatus.numberOfLines = 1;
    orderStatus.textAlignment = NSTextAlignmentLeft;
    orderStatus.font = [UIFont systemFontOfSize:13];
    orderStatus.textColor = UICOLOR(217, 30, 38);
    //orderStatus.text = @"待支付";
    [superView addSubview:orderStatus];
    [orderStatus sizeToFit];
    [orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderId.centerY);
        make.left.equalTo(orderId.right).offset(10);
    }];
    _orderStatus = orderStatus;
    
    UILabel *orderDate = [UILabel new];
    orderDate.numberOfLines = 1;
    orderDate.textAlignment = NSTextAlignmentRight;
    orderDate.font = [UIFont systemFontOfSize:13];
    orderDate.textColor = [UIColor lightGrayColor];
    //orderDate.text = @"2016年10月20日 19:25";
    [superView addSubview:orderDate];
    [orderDate sizeToFit];
    [orderDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderId.centerY);
        make.right.equalTo(superView.right).offset(-offsetX);
    }];
    _orderDate = orderDate;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(orderId.bottom).offset(10);
        make.height.equalTo(0.5);
    }];
    
    float imageWidth = 70;
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.left);
        make.top.equalTo(line.bottom).offset(5);
        make.height.equalTo(imageWidth);
        make.width.equalTo(imageWidth);
    }];
    //NSString *s = @"http://doc.woeatapp.com/ui/resource/DummyImages/Dishes/02.jpg";
    //NSURL *url = [NSURL URLWithString:s];
    //[imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _imgView = imgView;
    
    float offsetLeft = COND_WIDTH_320(15, 10);
    UILabel *kitchenName = [UILabel new];
    kitchenName.numberOfLines = 1;
    kitchenName.textAlignment = NSTextAlignmentLeft;
    kitchenName.font = [UIFont boldSystemFontOfSize:15];
    kitchenName.textColor = DARK_ORANGE_COLOR;
    //kitchenName.text = @"飘湘满楼";
    [superView addSubview:kitchenName];
    [kitchenName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offsetLeft);
        make.top.equalTo(imgView.top);
    }];
    _kitchenName = kitchenName;
    
    UILabel *diliver = [UILabel new];
    diliver.numberOfLines = 1;
    diliver.textAlignment = NSTextAlignmentLeft;
    diliver.font = [UIFont systemFontOfSize:11];
    diliver.textColor = [UIColor blackColor];
    //diliver.text = @"配送";
    [superView addSubview:diliver];
    [diliver sizeToFit];
    [diliver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenName.left);
        make.top.equalTo(kitchenName.bottom).offset(10);
    }];
    _diliver = diliver;
    
    UILabel *price = [UILabel new];
    price.numberOfLines = 1;
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont systemFontOfSize:11];
    price.textColor = [UIColor blackColor];
    //price.text = @"需支付: $36.00";
    [superView addSubview:price];
    [price sizeToFit];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(diliver.right).offset(20);
        make.centerY.equalTo(diliver.centerY);
    }];
    _price = price;
    
    UIImage *redArrow = [UIImage imageNamed:@"icon_arrow_red"];
    UIImage *grayArrow = [UIImage imageNamed:@"icon_arrow_gray"];
    WERightImageButton *detailButton = [[WERightImageButton alloc] initWithImage:grayArrow title:@"订单详情"];
    detailButton.label.textColor = [UIColor lightGrayColor];
    [detailButton addTarget:self action:@selector(detailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(price.centerY);
        make.right.equalTo(line.right);
        make.width.equalTo([detailButton getWidth]);
        make.height.equalTo([detailButton getHeight]);
    }];
    _detailButton = detailButton;
    
    WERightImageButton *payButton = [[WERightImageButton alloc] initWithImage:redArrow title:@"去支付"];
    payButton.label.textColor = DARK_ORANGE_COLOR;
    [payButton addTarget:self action:@selector(payButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailButton.bottom).offset(30);
        make.right.equalTo(detailButton.right);
        make.width.equalTo([payButton getWidth]);
        make.height.equalTo([payButton getHeight]);
    }];
    _payButton = payButton;
    
    WERightImageButton *commentButton = [[WERightImageButton alloc] initWithImage:grayArrow title:@"写评价"];
    commentButton.label.textColor = [UIColor lightGrayColor];
    [commentButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imgView.bottom).offset(5);
        make.right.equalTo(line.right);
        make.width.equalTo([commentButton getWidth]);
        make.height.equalTo([commentButton getHeight]);
    }];
    _commentButton = commentButton;
    
    UIView *commentView = [UIView new];
    commentView.backgroundColor = [UIColor clearColor];
    [superView addSubview:commentView];
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price.bottom).offset(20);
        make.left.equalTo(diliver.left);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo([commentButton getHeight]);
    }];
    _commentView = commentView;
    
    superView = _commentView;
    UILabel *myCommentTitle = [UILabel new];
    myCommentTitle.numberOfLines = 1;
    myCommentTitle.textAlignment = NSTextAlignmentLeft;
    myCommentTitle.font = [UIFont systemFontOfSize:11];
    myCommentTitle.textColor = [UIColor blackColor];
    myCommentTitle.text = @"我的评价";
    [superView addSubview:myCommentTitle];
    [myCommentTitle sizeToFit];
    [myCommentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.top);
        make.left.equalTo(superView.left);
    }];
   
    UILabel *myCommentContent = [UILabel new];
    myCommentContent.numberOfLines = 1;
    myCommentContent.textAlignment = NSTextAlignmentLeft;
    myCommentContent.font = [UIFont systemFontOfSize:11];
    myCommentContent.textColor = [UIColor grayColor];
    //myCommentContent.text = @"有点贵。送餐慢";
    [superView addSubview:myCommentContent];
    [myCommentContent sizeToFit];
    [myCommentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myCommentTitle.bottom).offset(10);
        make.left.equalTo(superView.left);
    }];
    
    UIView *replyBg = [UIView new];
    replyBg.backgroundColor = UICOLOR(238, 238, 238);
    [superView addSubview:replyBg];
    [replyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myCommentContent.left);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(myCommentContent.bottom).offset(10);
        //make.bottom.equalTo(imgView.bottom).offset(-bottomSpace);
    }];
    
    superView = replyBg;
    float replyOffsetX = 5;
    float replyVSpace = 8;
    UILabel *replyHeader = [UILabel new];
    replyHeader.numberOfLines = 1;
    replyHeader.textAlignment = NSTextAlignmentLeft;
    replyHeader.font = [UIFont systemFontOfSize:11];
    replyHeader.textColor = [UIColor blackColor];
    //replyHeader.text = @"家厨回复";
    [superView addSubview:replyHeader];
    [replyHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(replyOffsetX);
        make.top.equalTo(superView.top).offset(replyVSpace);
        make.right.equalTo(superView.right).offset(-replyOffsetX);
        make.height.equalTo(replyHeader.font.pointSize+1);
    }];
    
    float contentWidth = [WEUtil getScreenWidth] - (offsetX + imageWidth + offsetLeft) - offsetX;
    UILabel *replyContent = [UILabel new];
    replyContent.numberOfLines = 0;
    replyContent.textAlignment = NSTextAlignmentLeft;
    replyContent.lineBreakMode = NSLineBreakByWordWrapping;
    replyContent.font = [UIFont systemFontOfSize:11];
    replyContent.textColor = UICOLOR(180, 180, 180);
    //replyContent.text = @"谢谢评论，我们注意改进服务质量";
    [superView addSubview:replyContent];
    float replyContentWidth = contentWidth - replyOffsetX - replyOffsetX;
    CGSize replyContentSize = [WEUtil sizeForTitle:replyContent.text font:replyContent.font maxWidth:replyContentWidth];
    [replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(replyOffsetX);
        make.top.equalTo(replyHeader.bottom).offset(replyVSpace);
        make.right.equalTo(superView.right).offset(-replyOffsetX);
        //make.bottom.equalTo(superView.bottom).offset(-vSpace);
    }];
    
    float replyHeight = replyVSpace + replyHeader.font.pointSize+1 + replyVSpace + replyContentSize.height + replyVSpace;
    [replyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(replyHeight);
    }];


    
    return self;
}


- (void)setType:(WEMainOrderViewCellType)type
{
    _type = type;
}

- (void)detailButtonTapped:(UIButton *)button
{
    WEOrderDetailViewController *c = [WEOrderDetailViewController new];
    c.order = _order;
    WEModelGetConsumerKitchen *kitchenInfo = [WEModelGetConsumerKitchen new];
    WEKitchenCache *cache = [WEKitchenCache sharedInstance];
    kitchenInfo.Name = [cache getNameForKitchenId:_order.KitchenId];
    kitchenInfo.PortraitImageUrl = [cache getImageUrlForKitchenId:_order.KitchenId];
    c.kitchenInfo = kitchenInfo;
    c.isToday = [WEUtil isTodayTime:_order.RequiredArrivalTime];
    [self.controller.navigationController pushViewController:c animated:YES];
}

- (void)payButtonTapped:(UIButton *)button
{
    if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNPAID]) {
        WEOrderPayViewController *c = [WEOrderPayViewController new];
        c.order = _order;
        c.isToday = [WEUtil isTodayTime:_order.RequiredArrivalTime];
        WEModelGetConsumerKitchen *kitchenInfo = [WEModelGetConsumerKitchen new];
        WEKitchenCache *cache = [WEKitchenCache sharedInstance];
        kitchenInfo.Name = [cache getNameForKitchenId:_order.KitchenId];
        kitchenInfo.PortraitImageUrl = [cache getImageUrlForKitchenId:_order.KitchenId];
        c.kitchenInfo = kitchenInfo;
        [self.controller.navigationController pushViewController:c animated:YES];
     
    } else  if ([_order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        WEOrderConfirmViewController *c = [WEOrderConfirmViewController new];
        c.orderId = _order.Id;
        c.isToday = [WEUtil isTodayTime:_order.RequiredArrivalTime];
        WEModelGetConsumerKitchen *kitchenInfo = [WEModelGetConsumerKitchen new];
        WEKitchenCache *cache = [WEKitchenCache sharedInstance];
        kitchenInfo.Id = _order.KitchenId;
        kitchenInfo.Name = [cache getNameForKitchenId:_order.KitchenId];
        kitchenInfo.PortraitImageUrl = [cache getImageUrlForKitchenId:_order.KitchenId];
        kitchenInfo.CanPickup = [cache getCanPickupForKitchenId:_order.KitchenId];
        kitchenInfo.CanDeliver = [cache getCanDiliverForKitchenId:_order.KitchenId];
        c.kitchenInfo = kitchenInfo;
        [self.controller.navigationController pushViewController:c animated:YES];
    
    }
    
}


- (void)commentButtonTapped:(UIButton *)button
{
    WEOrderAddCommentViewController *c = [WEOrderAddCommentViewController new];
    c.order = _order;
    WEModelGetConsumerKitchen *kitchenInfo = [WEModelGetConsumerKitchen new];
    WEKitchenCache *cache = [WEKitchenCache sharedInstance];
    kitchenInfo.Name = [cache getNameForKitchenId:_order.KitchenId];
    kitchenInfo.PortraitImageUrl = [cache getImageUrlForKitchenId:_order.KitchenId];
    c.kitchenInfo = kitchenInfo;
    [self.controller.navigationController pushViewController:c animated:YES];
}




+ (float)getHeightWithType:(WEMainOrderViewCellType)type
{
    if (type == WEMainOrderViewCellType_FINISHED) {
        return CELL_TOP + CELL_BOTTOM + 200;
    } else {
        return CELL_TOP + CELL_BOTTOM + 120;
    }
    
}

- (void)setKitchenNameImage:(WEModelOrder *)order
{
    WEKitchenCache *cache = [WEKitchenCache sharedInstance];
    NSString *name = [cache getNameForKitchenId:order.KitchenId];
    NSString *imageUrl = [cache getImageUrlForKitchenId:order.KitchenId];
    if (name.length) {
        _kitchenName.text = name;
    }
    if (imageUrl.length) {
        NSString *s = imageUrl;
        NSURL *url = [NSURL URLWithString:s];
        [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    }

    if (!name.length || !imageUrl.length) {
        [WENetUtil GetConsumerKitchenWithKitchenId:order.KitchenId Latitude:TEST_Latitude Longitude:TEST_Longitude success:^(NSURLSessionDataTask *task, id responseObject) {
            
            JSONModelError* error = nil;
            NSDictionary *dict = (NSDictionary *)responseObject;
            WEModelGetConsumerKitchen *model = [[WEModelGetConsumerKitchen alloc] initWithDictionary:dict error:&error];
            if (error) {
                NSLog(@"error %@", error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cache setName:model.Name forKitchenId:order.KitchenId];
                [cache setImageUrl:model.PortraitImageUrl forKitchenId:order.KitchenId];
                [cache setCanPickup:model.CanPickup forKitchenId:order.KitchenId];
                [cache setCanDiliver:model.CanDeliver forKitchenId:order.KitchenId];
                _kitchenName.text = model.Name;
                NSString *s = model.PortraitImageUrl;
                NSURL *url = [NSURL URLWithString:s];
                [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
                
            });
            
        } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
            NSLog(@"errorMsg %@", errorMsg);
        }];
    }
}

- (void)setData:(WEModelOrder *)order
{
    _order = order;
    if (!order) {
        return;
    }
    
    _orderId.text = [NSString stringWithFormat:@"订单号 %@", order.Id];
    if ([order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        _orderDate.text = [WEUtil convertFullDateStringToSimple:order.TimeCreated];
    } else {
        _orderDate.text = [WEUtil convertFullDateStringToSimple:order.RequiredArrivalTime];
    }
    
    _payButton.hidden = NO;
    if ([order.OrderStatus isEqualToString:WEOrderStatus_UNSUBMITTEDD]) {
        _payButton.label.text = @"去提交";
    } else if([order.OrderStatus isEqualToString:WEOrderStatus_UNPAID]) {
        _payButton.label.text = @"去支付";
    }else {
        _payButton.hidden = YES;
    }
    
    if ([order.DispatchMethod isEqualToString:@"PICKUP"]) {
        _diliver.text = @"自取";
    } else if ([order.DispatchMethod isEqualToString:@"DELIVER"]){
        _diliver.text = @"配送";
    }
    
    _orderStatus.text = [WEOrderStatus getDesc:order.OrderStatus];
    _orderStatus.textColor = [UIColor redColor];
    if (order.IsFullyPaid) {
        _price.text = @"已支付";
    } else {
        _price.text = [NSString stringWithFormat:@"需支付: $%.2f",order.PayableValue];
    }
    
    if (_type == WEMainOrderViewCellType_ON_GOING) {
        _detailButton.hidden = NO;
        _commentButton.hidden = YES;
        _commentView.hidden = YES;
        
        [self setKitchenNameImage:order];
        
    } else if (_type == WEMainOrderViewCellType_WAIT_COMMENT) {
        _detailButton.hidden = YES;
        _commentButton.hidden = NO;
        _commentView.hidden = YES;
        
        [self setKitchenNameImage:order];
        
    } else {
    }
    
}


@end
