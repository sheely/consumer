//
//  WEUtil.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEUtil.h"

@implementation WEUtil


+ (int)getScreenWidth {
    CGRect rect = [[UIScreen mainScreen] bounds];
    return rect.size.width;
}

+ (int)getScreenHeight {
    CGRect rect = [[UIScreen mainScreen] bounds];
    return rect.size.height;
}

+ (float)cond:(float)normal height_480:(float)only4s
{
    if ([self getScreenHeight] < 500) {
        return only4s;
    } else {
        return normal;
    }
}

+ (float)cond:(float)normal width_320:(float)w
{
    if ([self getScreenWidth] < 330) {
        return w;
    } else {
        return normal;
    }
}

//http://blog.csdn.net/xjkstar/article/details/47165983
+ (CGSize)sizeForTitle:(NSString*)text font:(UIFont*)font maxWidth:(float)maxWidth
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    CGSize textSize = CGSizeZero;
    
    
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    else{
        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    textSize.height += 0.5;
    textSize.width += 0.5;
    return textSize;
}


+ (CGSize)oneLineSizeForTitle:(NSString*)text font:(UIFont*)font
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    size.width += 0.5;
    size.height += 0.5;
    return size;
}


+ (UIImage*) imageByScalingAndCroppingForSize:(UIImage *)origin targetSize:(CGSize)targetSize
{
    UIImage *sourceImage = origin;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIScreen *screen = [UIScreen mainScreen];
    if([screen respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, [screen scale]);
    }else{
        UIGraphicsBeginImageContext(targetSize);
    }
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSAttributedString *)getAttributeStringWithNormalFont:(UIFont *)normalFont
                                             normalColor:(UIColor *)normalColor
                                            normalString:(NSString *)normalString
                                           highlightFont:(UIFont *)highlightFont
                                          highlightColor:(UIColor *)hilightColor
                                         highlightString:(NSString *)highlightString
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:normalString];
    [attrStr addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, normalString.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:normalColor
                    range:NSMakeRange(0, normalString.length)];
    if (!highlightString.length) {
        return attrStr;
    }
    
    int searchStartIndex = 0;
    while (true) {
        NSRange r = [normalString rangeOfString:highlightString
                                        options:NSCaseInsensitiveSearch
                                          range:NSMakeRange(searchStartIndex, normalString.length-searchStartIndex)
                                         locale:[NSLocale currentLocale]];
        if (r.location != NSNotFound) {
            [attrStr addAttribute:NSFontAttributeName value:highlightFont range:r];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:hilightColor
                            range:r];
            
        } else {
            break;
        }
        searchStartIndex = r.location + r.length;
    }
    return attrStr;
}

+ (NSString *)convertFullDateStringToSimple:(NSString *)full
{
    NSDateFormatter *input = [[NSDateFormatter alloc] init];
    [input setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [input dateFromString:full];
    if (!date) {
        NSRange r = [full rangeOfString:@"."];
        if (r.location != NSNotFound) {
            if (r.location == full.length-4) {
                full = [full substringWithRange:NSMakeRange(0, r.location)];
                date = [input dateFromString:full];
            }
        }
    }
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *time = [output stringFromDate:date];
    return time;
}

+ (BOOL)isTodayTime:(NSString *)full
{
    NSDateFormatter *input = [[NSDateFormatter alloc] init];
    [input setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [input dateFromString:full];
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [output stringFromDate:date];
    
    NSDate *now = [NSDate date];
    NSString *time1 = [output stringFromDate:date];
    return [time isEqualToString:time1];
}

@end
