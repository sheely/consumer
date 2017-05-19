//
//  WEHomeKitchenCellTableViewCell.m
//  woeat
//
//  Created by liubin on 16/10/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenCellTableViewCell.h"
#import "WEUtil.h"
#import "UIImageView+WebCache.h"
#import "WERoundTextView.h"
#import "YYKit.h"
#import "WEModelGetList.h"
#import "WENetUtil.h"

#define TEXT_COLOR UICOLOR(153,153,153)

@interface WEHomeKitchenCellTableViewCell()
{
    UIImageView *_imgView;
    UILabel *_name;
    UILabel *_title;
    UILabel *_distance;
    UILabel *_sale;
    WERoundTextView *_flavour;
    UILabel *_hasCollectTip;
    UIButton *_hasCollectButton;
    UIButton *_addCollectButton;
    UIImageView *_certifiedImageView;
}

@end

@implementation WEHomeKitchenCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];

    
    UIView *superView = self.contentView;
    
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(240,239,245);
    [superView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.top.equalTo(superView.top).offset(3);
        make.bottom.equalTo(superView.bottom).offset(-3);
        make.right.equalTo(superView.right).offset(-20);
    }];
    
    superView = bg;
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    float imgWidth = COND_WIDTH_320(80, 80);
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(10);
        make.top.equalTo(superView.top).offset(12);
        make.width.equalTo(imgWidth);
        make.height.equalTo(imgWidth);
    }];
    _imgView = imgView;
    
    
    float offset = COND_WIDTH_320(15, 5);
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = DARK_ORANGE_COLOR;
    [superView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offset);
        make.right.equalTo(superView.right).offset(-50);
        make.top.equalTo(imgView.top).offset(2);
        make.height.equalTo(16);
    }];
    _name = name;
    
    UILabel *title = [UILabel new];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = TEXT_COLOR;
    [superView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.right.equalTo(name.right);
        make.top.equalTo(name.bottom).offset(5);
        make.height.equalTo(16);
    }];
    _title = title;
    
    UIImageView *locIcon = [UIImageView new];
    locIcon.backgroundColor = [UIColor clearColor];
    locIcon.image = [UIImage imageNamed:@"icon_location_gray"];
    [superView addSubview:locIcon];
    [locIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(title.bottom).offset(5);
        make.width.equalTo(12);
        make.height.equalTo(12);
    }];

    UILabel *distance = [UILabel new];
    distance.numberOfLines = 1;
    distance.textAlignment = NSTextAlignmentLeft;
    distance.font = [UIFont systemFontOfSize:13];
    distance.textColor = TEXT_COLOR;
    [superView addSubview:distance];
    [distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locIcon.right).offset(3);
        make.right.equalTo(title.right);
        make.centerY.equalTo(locIcon.centerY);
        make.height.equalTo(16);
    }];
    _distance = distance;
    
    UILabel *sale = [UILabel new];
    sale.numberOfLines = 1;
    sale.textAlignment = NSTextAlignmentLeft;
    sale.font = [UIFont systemFontOfSize:13];
    sale.textColor = TEXT_COLOR;
    [superView addSubview:sale];
    [sale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locIcon.left);
        make.right.equalTo(title.right);
        make.top.equalTo(locIcon.bottom).offset(5);
        make.height.equalTo(16);
    }];
    _sale = sale;

    
    WERoundTextView *flavour = [WERoundTextView new];
    flavour.textBgColor = UICOLOR(184,184,184);
    flavour.textFont = [UIFont systemFontOfSize:14];
    flavour.textInset = UIEdgeInsetsMake(-4, -10, -4, -10);
    flavour.cornerRadius = 4;
    [superView addSubview:flavour];
    [flavour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locIcon.left).offset(0);
        make.top.equalTo(sale.bottom).offset(5);
        make.width.equalTo([flavour getWidth]);
        make.height.equalTo([flavour getHeight]);
    }];
    _flavour = flavour;
    
    UILabel *collect= [UILabel new];
    collect.numberOfLines = 1;
    collect.textAlignment = NSTextAlignmentCenter;
    collect.font = [UIFont systemFontOfSize:13];
    collect.textColor = TEXT_COLOR;
    [superView addSubview:collect];
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-5);
        make.bottom.equalTo(superView.bottom).offset(-10);
    }];
    _hasCollectTip = collect;
    _hasCollectTip.text = @"已收藏";

    UIImage *collectImage = [UIImage imageNamed:@"icon_home_favourite"];
    UIButton *collectButton = [UIButton new];
    [collectButton setBackgroundImage:collectImage forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(removeCollect:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:collectButton];
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collect.centerX);
        make.bottom.equalTo(collect.top).offset(-10);
        make.width.equalTo(collectImage.size.width);
        make.height.equalTo(collectImage.size.height);
    }];
    _hasCollectButton = collectButton;
    
    UIButton *addCollectButton = [UIButton new];
    addCollectButton.backgroundColor = [UIColor lightGrayColor];
    addCollectButton.titleLabel.font = [UIFont systemFontOfSize:13];
    NSString *collectTitle = @"加入收藏";
    [addCollectButton setTitle:collectTitle forState:UIControlStateNormal];
    [addCollectButton addTarget:self action:@selector(addCollect:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:addCollectButton];
    CGSize size = [WEUtil oneLineSizeForTitle:collectTitle font:addCollectButton.titleLabel.font];
    [addCollectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-5);
        make.bottom.equalTo(superView.bottom).offset(-5);
        make.width.equalTo(size.width+4);
        make.height.equalTo(size.height);
    }];
    _addCollectButton = addCollectButton;
    
    UIImage *certImage = [UIImage imageNamed:@"icon_home_certified"];
    UIImageView *cert = [UIImageView new];
    cert.image = certImage;
    [superView addSubview:cert];
    [cert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(0);
        make.top.equalTo(superView.top).offset(0);
        make.width.equalTo(certImage.size.width);
        make.height.equalTo(certImage.size.height);
    }];
    _certifiedImageView = cert;
    return self;
}

- (void)setData:(id)data
{
    if (!data) {
        return;
    }
    if (![data isKindOfClass:[WEModelGetListKitchens class]]) {
        NSLog(@"setData class error, should be %@, but %@", [WEModelGetListKitchens class], [data class]);
        return;
    }
    _data = data;
    
    WEModelGetListKitchens *model = (WEModelGetListKitchens *)data;
    
    NSString *s = model.PortraitImageUrl;
    NSURL *url = [NSURL URLWithString:s];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //NSLog(@"========error=%@, image size %p, %f,%f", error, image, image.size.width, image.size.height);
        //NSLog(@"_imgView.image %p", _imgView.image);
    }];
    
    _name.text = model.Name;
    _distance.text = model.FormattedDistanceString;
    if ([model.IsMyFavourite boolValue]) {
        _hasCollectTip.hidden = NO;
        _hasCollectButton.hidden = NO;
        _addCollectButton.hidden = YES;
    } else {
        _hasCollectTip.hidden = YES;
        _hasCollectButton.hidden = YES;
        _addCollectButton.hidden = NO;
    }
    
    if ([model.IsCertified boolValue]) {
        _certifiedImageView.hidden = NO;
    } else {
        _certifiedImageView.hidden = YES;
    }

    
//    NSString *s = @"http://doc.woeatapp.com/ui/resource/DummyImages/Dishes/01.jpg";
//    NSURL *url = [NSURL URLWithString:s];
//    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
//    
//    _name.text = @"飘湘满楼";
//    _title.text = @"Hectorville第一家厨";
//    _distance.text = @"距离 约小于1公里";
//    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"月售 "];
    one.font = [UIFont systemFontOfSize:13];
    one.color = TEXT_COLOR;
    [text appendAttributedString:one];
    NSString *MonthlyOrderCount = [NSString stringWithFormat:@"%@", model.MonthlyOrderCount];
    NSMutableAttributedString *two = [[NSMutableAttributedString alloc] initWithString:MonthlyOrderCount];
    two.font = [UIFont systemFontOfSize:13];
    two.color = DARK_ORANGE_COLOR;
    [text appendAttributedString:two];
    NSString *MonthlyAverageOrderValue = [NSString stringWithFormat:@" 单|人均 $%.1f", model.MonthlyAverageOrderValue.floatValue];
    NSMutableAttributedString *three = [[NSMutableAttributedString alloc] initWithString:MonthlyAverageOrderValue];
    three.font = [UIFont systemFontOfSize:13];
    three.color = TEXT_COLOR;
    [text appendAttributedString:three];
    _sale.attributedText = text;
//    [_flavour setString:@"湘菜"];
//    _collect.text = @"已收藏";
}


- (void)removeCollect:(UIButton *)button
{
    WEModelGetListKitchens *model = (WEModelGetListKitchens *)_data;
    NSString *kitchenId = model.KitchenId;
    model.IsMyFavourite = @NO;
    [self setData:_data];
    
    [WENetUtil UserFavouriteRemoveKitchenWithKitchenId:kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KITCHEN_FAV_CHANGE object:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        model.IsMyFavourite = @YES;
        [self setData:_data];
    }];
}

- (void)addCollect:(UIButton *)button
{
    WEModelGetListKitchens *model = (WEModelGetListKitchens *)_data;
    NSString *kitchenId = model.KitchenId;
    model.IsMyFavourite = @YES;
    [self setData:_data];
    
    [WENetUtil UserFavouriteAddKitchenWithKitchenId:kitchenId success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KITCHEN_FAV_CHANGE object:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        model.IsMyFavourite = @NO;
        [self setData:_data];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
