//
//  WEProfileImage.m
//  woeat
//
//  Created by liubin on 17/1/5.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEProfileImage.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "WEGlobalData.h"

#define IMAGE_NAME @"profile.jpg"

@implementation WEProfileImage

+ (NSString *)getProfileImagePath
{
    NSString *parentDir = [[WEGlobalData sharedInstance] getUserDir];
    return [parentDir stringByAppendingPathComponent:IMAGE_NAME];
}

+ (void)saveProfileImage:(UIImage *)img
{
    NSString *path = [self getProfileImagePath];
    NSData *data = UIImageJPEGRepresentation(img, 1);
    [data writeToFile:path atomically:YES];
}

+ (UIImage *)loadProfileImage
{
    NSString *path = [self getProfileImagePath];
    return [UIImage imageWithContentsOfFile:path];
}

+ (void)downloadImage:(NSString *)url
{
    NSLog(@"downloadImage url %@", url);
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *_downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"progress %lld, %lld", downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *url = [NSURL fileURLWithPath:[self getProfileImagePath]];
        //NSLog(@"url %@", url);
        return url;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"download profile image %@", [self getProfileImagePath]);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PROFILE_IMAGE_RELOAD object:nil];
    }];
    [_downloadTask resume];
}



@end
