//
//  WEHomeKitchenViewCellTableViewCell.m
//  woeat
//
//  Created by liubin on 16/10/21.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenViewCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WERoundTextView.h"
#import "YYKit.h"
#import "WEUtil.h"


@interface WEHomeKitchenViewCellTableViewCell()
{
    UIImageView *_imgView;
    UILabel *_nameLabel;
    WERoundTextView *_flavour;
    UILabel *_priceLabel;
    UILabel *_descLabel;
    UILabel *_amountLabel;
}

@end



@implementation WEHomeKitchenViewCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(10);
        make.top.equalTo(superView.top).offset(0);
        make.bottom.equalTo(superView.bottom).offset(-40);
        make.width.equalTo([WEUtil getScreenWidth]*0.4);
    }];
    //NSString *s = @"http://doc.woeatapp.com/ui/resource/DummyImages/Dishes/02.jpg";
    //NSURL *url = [NSURL URLWithString:s];
    //[imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _imgView = imgView;
    
    float offsetLeft = COND_WIDTH_320(15, 10);
    float offsetRight = COND_WIDTH_320(15, 10);
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont boldSystemFontOfSize:13];
    name.textColor = [UIColor blackColor];
    //name.text = @"彩椒鸡肉饭";
    [superView addSubview:name];
    [name sizeToFit];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offsetLeft);
        make.top.equalTo(imgView.top).offset(2);
    }];
    _nameLabel = name;
    
    WERoundTextView *flavour = [WERoundTextView new];
    flavour.textBgColor = [UIColor blackColor];
    flavour.textFont = [UIFont systemFontOfSize:11];
    flavour.textInset = UIEdgeInsetsMake(-2, -5, -2, -5);
    flavour.cornerRadius = 3;
    [flavour setString:@"招牌菜"];
    [superView addSubview:flavour];
    [flavour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.left).offset(10);
        make.top.equalTo(imgView.top).offset(10);
        make.width.equalTo([flavour getWidth]).priorityHigh();
        make.height.equalTo([flavour getHeight]);
    }];
    _flavour = flavour;
    _flavour.hidden = YES;
    
    UILabel *price = [UILabel new];
    price.numberOfLines = 1;
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont boldSystemFontOfSize:13];
    price.textColor = DARK_ORANGE_COLOR;
    //price.text = @"$ 25.00";
    [superView addSubview:price];
//    size = [price.text sizeWithAttributes:@{NSFontAttributeName : price.font}];
    [price sizeToFit];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offsetRight);
        make.centerY.equalTo(name.centerY);
        make.left.greaterThanOrEqualTo(name.right);
//        make.width.equalTo(size.width+0.5);
//        make.height.equalTo(size.height);
    }];
    _priceLabel = price;
 
    UILabel *desc = [UILabel new];
    desc.numberOfLines = 0;
    desc.textAlignment = NSTextAlignmentLeft;
    desc.font = [UIFont systemFontOfSize:14];
    desc.textColor = UICOLOR(150, 150, 150);
    //desc.text = @"上等鸡肉配以德克萨斯州原产彩椒，无msg配方。咸鲜适口，回味无穷";
    [superView addSubview:desc];
   // size = [desc.text sizeWithAttributes:@{NSFontAttributeName : desc.font}];
    [desc sizeToFit];
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(name.bottom).offset(8);
        make.right.equalTo(price.right);
        //make.height.equalTo(10).priorityMedium();
    }];
    _descLabel = desc;

    UIImage *addImg = [UIImage imageNamed:@"icon_plus"];
    UIButton *add = [UIButton new];
    [add setBackgroundImage:addImg forState:UIControlStateNormal];
    [superView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(desc.right).offset(-3);
        make.width.equalTo(addImg.size.width);
        make.height.equalTo(addImg.size.height);
        make.bottom.equalTo(imgView.bottom).offset(-5);
    }];
    _addButton = add;
    
    UILabel *amount = [UILabel new];
    amount.numberOfLines = 1;
    amount.textAlignment = NSTextAlignmentLeft;
    amount.font = [UIFont systemFontOfSize:14];
    amount.textColor = UICOLOR(0, 0, 0);
    //amount.text = @"还有5份";
    [superView addSubview:amount];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.centerY.equalTo(add.centerY);
        make.right.equalTo(add.left);
        make.height.equalTo(amount.font.pointSize+1);
        make.top.greaterThanOrEqualTo(desc.bottom);
    }];
    _amountLabel = amount;
    
    return self;
}

- (void)setIsEmpty:(BOOL)isEmpty
{
//    _isEmpty = isEmpty;
//    _flavour.textInset = UIEdgeInsetsMake(-1, -8, -1, -8);
//    _flavour.onlyBorder = _isEmpty;
//    if (_isEmpty) {
//         [_flavour setString:@"主打"];
//    } else {
//        [_flavour setString:@"招牌菜"];
//    }
//    [_flavour mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo([_flavour getWidth]).priorityHigh();
//    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WEModelGetTodayListItemList *)model
{
    if (model.PortraitImageUrl.length) {
        NSString *s = model.PortraitImageUrl;
        NSURL *url = [NSURL URLWithString:s];
        [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    _nameLabel.text = model.Name;
    if (model.IsFeatured) {
        _flavour.hidden = NO;
    } else {
        _flavour.hidden = YES;
    }
    _priceLabel.text = [NSString stringWithFormat:@"$ %.2f", model.UnitPrice];
    _descLabel.text = model.Description;
    _amountLabel.text = [NSString stringWithFormat:@"还有%d份", model.CurrentAvailability];
}

- (void)setCurrentAmount:(int)amount
{
    _amountLabel.text = [NSString stringWithFormat:@"还有%d份", amount];
}

@end
