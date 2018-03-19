//
//  PhotoPickerManager.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumModel.h"
#import "PhotoModel.h"
#import "VideoModel.h"

@interface PhotoPickerManager : NSObject

@property (nonatomic, strong) NSMutableArray *albumArray;

@property (nonatomic, strong) AlbumModel *defaultModel;

@property (nonatomic, strong) PHFetchResult *defaultFetch;

+ (PhotoPickerManager *)manager;

/**
 *  相册授权状态
 */
+ (PHAuthorizationStatus)photoLibraryAuthorizationStatus;

/**
 *  相册授权
 */
+ (void)photoLibraryAuthorization:(void(^)(PHAuthorizationStatus status))handler;

/**
 *  获取所有相册
 */
- (void)allAlbumsSuccess:(void(^)(NSArray <AlbumModel *>*result))success;

/**
 *  获取相册内所有照片
 */
- (void)photosWithFetch:(PHFetchResult *)fetchResult Page:(NSInteger)page Limit:(NSInteger)limit Success:(void(^)(NSArray *result))success;


/**
 *  保存图片
 */
- (void)saveImageToAlbumWithUrl:(NSString *)imageUrl Complete:(void (^)(void))complete;

- (void)saveImageToAlbum:(UIImage *)image Complete:(void (^)(void))complete;

//加载图片
- (void)loadThumImageWithAssets:(PHAsset *)asset Success:(void(^)(UIImage *result))success;

- (void)loadImageWithAssets:(PHAsset *)asset Success:(void(^)(UIImage *result))success;

- (void)loadOrgImageWithAssets:(PHAsset *)asset Success:(void(^)(UIImage *result))success;

- (void)loadImageWithAssets:(PHAsset *)asset maxSize:(CGSize)maxSize Success:(void(^)(UIImage *result))success;

- (void)loadThumImageWithAssets:(PHAsset *)asset maxSize:(CGSize)maxSize Success:(void(^)(UIImage *result))success;

- (void)loadOrgImageWithAssets:(PHAsset *)asset maxSize:(CGSize)maxSize Success:(void(^)(UIImage *result))success;

//加载视频
- (void)loadHighQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success;

- (void)loadMediumQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success;

- (void)loadAutomaticQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success;

- (void)loadFastQualityVideoPlayerItemWithAsset:(PHAsset *)asset Success:(void(^)(AVPlayerItem *playerItem))success;


@end
