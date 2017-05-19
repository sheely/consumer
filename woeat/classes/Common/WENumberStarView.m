//
//  WENumberStarView.m
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WENumberStarView.h"

@interface WENumberStarView()
{
}
@end

@implementation WENumberStarView



- (void)setStarFull:(int)full half:(int)half empty:(int)empty
{
    
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    UIImageView *lastView = nil;
    for(int i=0; i<5; i++) {
        UIImageView *imgView = [UIImageView new];
        if (i < full) {
            imgView.image = [UIImage imageNamed:@"five_star_polygon"];
        } else {
            imgView.image = [UIImage imageNamed:@"five_star_polygon_empty"];
        }
        
        [superView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(superView.left);
            } else {
                make.left.equalTo(lastView.right).offset(2);
            }
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(13);
            make.height.equalTo(12.5);
        }];
        lastView = imgView;
    }

}

- (CGFloat)getWidth
{
    int total = 5;
    CGFloat width = 13 * total + 2 * (total-1);
    return width;
}

- (CGFloat)getHeight
{
    return 12.5;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
