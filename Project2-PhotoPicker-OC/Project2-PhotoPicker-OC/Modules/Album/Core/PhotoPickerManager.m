//
//  PhotoPickerManager.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoPickerManager.h"
#import <Photos/Photos.h>

@implementation PhotoPickerManager

+ (PhotoPickerManager *)manager {
    static PhotoPickerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PhotoPickerManager alloc] init];
    });
    return manager;
}

/**
 *  相册授权状态
 */
+ (PHAuthorizationStatus)photoLibraryAuthorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

/**
 *  相册授权
 */
+ (void)photoLibraryAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorization:handler];
}

/**
 *  获取所有相册
 */
- (void)allAlbumsSuccess:(void(^)(NSArray <AlbumModel *>*result))success {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self.albumArray removeAllObjects];
        
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        if (albums.count == 0) {
            
        }
        [albums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *collection = (PHAssetCollection *)obj;
            NSLog(@"yangjing_album: collection = %@", collection.localizedTitle);

            PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
            // 按图片生成时间排序
            photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:photosOptions];
            if (![self isDeleteAlbum:collection.localizedTitle] && ![self isVideoAlbum:collection.localizedTitle] && fetchResult.count>0) {
                AlbumModel *model = [AlbumModel new];
                model.title = [self transformAblumTitle:collection.localizedTitle];
                model.phFetch = fetchResult;
                model.photoCount = fetchResult.count;
                [self.albumArray addObject:model];
                
                if ([self isCameraRollAlbum:collection.localizedTitle]) {
                    self.defaultFetch = fetchResult;
                    self.defaultModel = model;
                }
            }
            
            if (idx == albums.count-1) {
//                dispatch_semaphore_signal(semaphore);
                NSLog(@"yangjing_album: stop1");
            }
            
        }];
        
    });
}

/**
 *  获取相册内所有照片
 */
- (void)photosWithFetch:(PHFetchResult *)fetchResult Page:(NSInteger)page Limit:(NSInteger)limit Success:(void(^)(NSArray *result))success {}


/**
 *  保存图片
 */
- (void)saveImageToAlbumWithUrl:(NSString *)imageUrl Complete:(void (^)(void))complete {}

- (void)saveImageToAlbum:(UIImage *)image Complete:(void (^)(void))complete {}

//加载图片
- (void)loadThumImageWithAssets:(PHAsset *)asset Success:(void(^)(UIImage *result))success {}

- (void)loadImageWithAssets:(PHAsset *)asset Success:(void(^)(UIImage *result))success {}

- (void)loadOrgImageWithAssets:(PHAsset *)asset Success:(void(^)(UIImage *result))success {}

- (void)loadImageWithAssets:(PHAsset *)asset maxSize:(CGSize)maxSize Success:(void(^)(UIImage *result))success {}

- (void)loadThumImageWithAssets:(PHAsset *)asset maxSize:(CGSize)maxSize Success:(void(^)(UIImage *result))success {}

- (void)loadOrgImageWithAssets:(PHAsset *)asset maxSize:(CGSize)maxSize Success:(void(^)(UIImage *result))success {}

//加载视频
- (void)loadHighQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success {}

- (void)loadMediumQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success {}

- (void)loadAutomaticQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success {}

- (void)loadFastQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success {}


- (NSString *)transformAblumTitle:(NSString *)title {
    
    return title;
}

- (BOOL)isCameraRollAlbum:(NSString *)albumName {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    if (version >= 800 && version <= 802) {
        return [albumName isEqualToString:@"最近添加"] || [albumName isEqualToString:@"Recently Added"];
    } else {
        return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
    }
}

- (BOOL)isDeleteAlbum:(NSString *)albumName {
    return [albumName containsString:@"Deleted"] || [albumName isEqualToString:@"最近删除"];
    
}

- (BOOL)isVideoAlbum:(NSString *)albumName {
    return [albumName containsString:@"Videos"] || [albumName isEqualToString:@"视频"];
    
}

@end
