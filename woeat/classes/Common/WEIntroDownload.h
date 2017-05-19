//
//  WEIntroDownload.h
//  woeat
//
//  Created by liubin on 16/11/6.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEIntroDownload : NSObject

+ (void)downloadIntroImage;

//return UIImage array
+ (NSArray *)getDispayImagePathArray;
@end
