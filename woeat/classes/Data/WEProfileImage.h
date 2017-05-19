//
//  WEProfileImage.h
//  woeat
//
//  Created by liubin on 17/1/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEProfileImage : NSObject

+ (void)saveProfileImage:(UIImage *)img;
+ (UIImage *)loadProfileImage;

+ (void)downloadImage:(NSString *)url;
@end
