//
//  WEIntroDownload.m
//  woeat
//
//  Created by liubin on 16/11/6.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEIntroDownload.h"
#import "WENetUtil.h"
#import "AFNetworking.h"
#import "WEUtil.h"

#define INTRO_DIR    @"introCache"
#define INTRO_IMAGE_PLIST  @"intro_image.plist"

#define INTRO_Id        @"Id"
#define INTRO_Name      @"Name"
#define INTRO_ImageId   @"ImageId"
#define INTRO_ImageUrl  @"ImageUrl"
#define INTRO_ClientKey  @"ClientKey"
#define INTRO_ValidTimeFrom  @"ValidTimeFrom"
#define INTRO_ValidTimeTo    @"ValidTimeTo"
//
#define INTRO_DisplayTime    @"DisplayTime"


@interface WEIntroDownload()
{
    
}

@end


@implementation WEIntroDownload

+ (NSString *)getIntroDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *dir =  [docDir stringByAppendingPathComponent:INTRO_DIR];
    if (! [[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}

+ (NSString *)getIntroImagePlistPath
{
    NSString *dir = [self getIntroDir];
    NSLog(@"intro dir is %@", dir);
    return [dir stringByAppendingPathComponent:INTRO_IMAGE_PLIST];
}

+ (void)mergeDownloadIntro:(NSArray *)downloadArray
{
    if ([self isSameIntro:downloadArray]) {
        NSLog(@"is same intro");
        return;
    }
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self getIntroImagePlistPath]];
    NSMutableArray *merge = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSDictionary *dict in array) {
        NSMutableDictionary *mute = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [merge addObject:mute];
    }
    
    //simple
    [merge addObjectsFromArray:downloadArray];
    [merge writeToFile:[self getIntroImagePlistPath] atomically:YES];
    
    //download file
    for(NSDictionary *dict in downloadArray) {
        NSString *imageId = [dict objectForKey:INTRO_ImageId];
        NSString *imageUrl = [dict objectForKey:INTRO_ImageUrl];
        NSString *path = [self getImagePath:imageId];
        [self downloadFile:imageUrl path:path];
    }
}

+ (BOOL)isSame:(NSDictionary *)dict1 withDict:(NSDictionary *)dict2
{
    if ([dict1[INTRO_Id] intValue] != [dict2[INTRO_Id] intValue]) {
        return NO;
    }
    if (![dict1[INTRO_Name] isEqualToString:dict2[INTRO_Name]]) {
        return NO;
    }
    if ([dict1[INTRO_ImageId] intValue] != [dict2[INTRO_ImageId] intValue]) {
        return NO;
    }
    return YES;
}

+ (BOOL)isArray:(NSArray *)array containDict:(NSDictionary *)dict
{
    for(int i=0; i<array.count; i++) {
        NSDictionary *dict1 = [array objectAtIndex:i];
        if ([self isSame:dict1 withDict:dict]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isSameIntro:(NSArray *)downloadArray
{
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self getIntroImagePlistPath]];
    for(NSDictionary *dict in downloadArray) {
        if (![self isArray:array containDict:dict]) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)isTimeValid:(NSDictionary *)dict
{
    NSString *from = dict[INTRO_ValidTimeFrom];
    NSString *to = dict[INTRO_ValidTimeTo];
    if (!from.length || !to.length) {
        return NO;
    }
    NSDateFormatter *input = [[NSDateFormatter alloc] init];
    [input setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateFrom = [input dateFromString:from];
    NSDate *dateTo = [input dateFromString:to];
    if (!dateFrom || !dateTo) {
        return NO;
    }
    NSDate *now = [NSDate date];
    if ([now timeIntervalSinceDate:dateFrom] > 0 &&
        [now timeIntervalSinceDate:dateTo] < 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getImagePath:(NSString *)imageId
{
    NSString *dir = [self getIntroDir];
    NSString *name = [NSString stringWithFormat:@"%@.jpg", imageId];
    NSString *path = [dir stringByAppendingPathComponent:name];
    return path;
}


//return UIImage array
+ (NSArray *)getDispayImagePathArray
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:3];

    NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self getIntroImagePlistPath]];
    NSMutableArray *merge = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSDictionary *dict in array) {
        NSMutableDictionary *mute = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [merge addObject:mute];
    }
    for(NSMutableDictionary *dict in merge) {
        NSString *imageId = [dict objectForKey:INTRO_ImageId];
        NSString *displayTime = [dict objectForKey:INTRO_DisplayTime];
        if (displayTime.length) {
            NSLog(@"getDispayImagePathArray, image %@, already shown at %@", imageId, displayTime);
            continue;
        }
        if (![self isTimeValid:dict]) {
            NSLog(@"getDispayImagePathArray, image %@, time not valid", imageId);
            continue;
        }
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self getImagePath:imageId]];
        if (image.size.width > 0 && image.size.height > 0) {
            [ret addObject:image];
            NSString *time = [NSString stringWithFormat:@"%@", [NSDate date]];
            [dict setObject:time forKey:INTRO_DisplayTime];
        }
    }
    
    if (ret.count) {
        [merge writeToFile:[self getIntroImagePlistPath] atomically:YES];
        return ret;
    } else {
        NSLog(@"getDispayImagePathArray, no image");
        return nil;
    }
}



+ (void)downloadIntroImage
{
    static BOOL downloaded = NO;
    if (downloaded) {
        return;
    }
    downloaded = YES;
    
    NSLog(@"downloadIntroImage");
    [WENetUtil getListForConsumerSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        NSArray *downloadArray = [dict objectForKey:@"SliderList"];
        [self mergeDownloadIntro:downloadArray];
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
        
    }];
    
}

+ (void)downloadFile:(NSString *)url path:(NSString *)path
{
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *_downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // @property int64_t totalUnitCount;  需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        // 给Progress添加监听 KVO
        //NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        //        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSLog(@"download imgFilePath %@", imgFilePath);
    }];
    [_downloadTask resume];
}


@end
