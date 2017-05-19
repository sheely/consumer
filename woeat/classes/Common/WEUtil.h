//
//  WEUtil.h
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>




#define RatioW_6SPlus   (SCREEN_WIDTH/414.0)
#define RatioH_6SPlus   (SCREEN_HEIGHT/736.0)

#define RATIO_Y(y) (RatioH_6SPlus*y)
#define RATIO_X(x) (RatioW_6SPlus*x)


#define COND_HEIGHT_480(x,y4s)  ([WEUtil cond:x height_480:y4s])
#define COND_WIDTH_320(x,y4s)   ([WEUtil cond:x width_320:y4s])

@interface WEUtil : NSObject


+ (int)getScreenWidth;
+ (int)getScreenHeight;

+ (float)cond:(float)normal height_480:(float)only4s;
+ (float)cond:(float)normal width_320:(float)w;

+ (CGSize)sizeForTitle:(NSString*)text font:(UIFont*)font maxWidth:(float)maxWidth;
+ (CGSize)oneLineSizeForTitle:(NSString*)text font:(UIFont*)font;

+ (UIImage*) imageByScalingAndCroppingForSize:(UIImage *)origin targetSize:(CGSize)targetSize;

+ (NSAttributedString *)getAttributeStringWithNormalFont:(UIFont *)normalFont
                                             normalColor:(UIColor *)normalColor
                                            normalString:(NSString *)normalString
                                           highlightFont:(UIFont *)highlightFont
                                          highlightColor:(UIColor *)hilightColor
                                         highlightString:(NSString *)highlightString;

+ (NSString *)convertFullDateStringToSimple:(NSString *)full;
+ (BOOL)isTodayTime:(NSString *)full;
@end
