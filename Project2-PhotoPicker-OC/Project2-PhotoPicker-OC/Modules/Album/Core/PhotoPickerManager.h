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

@property (nonatomic, copy, readonly) NSArray *albumArray;

+ (PhotoPickerManager *)manager;

/**
 *  加载相册
 */
- (void)allAlbumsIfRefresh:(BOOL)refresh success:(void(^)(NSArray <AlbumModel *>*result))success failure:(void(^)(void))failure;

- (void)photosWithFetch:(PHFetchResult *)fetchResult Page:(NSInteger)page Limit:(NSInteger)limit Success:(void(^)(NSArray *result))success;

/**
 *  加载图片
 *  (图片尺寸：接近或稍微大于指定尺寸；图片质量：在速度与质量中均衡)
 */
- (void)loadImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize success:(void(^)(UIImage *result))success;

/**
 *  加载图片
 *  (图片尺寸：接近或稍微大于指定尺寸；图片质量：速度优先)
 */
- (void)loadThumImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize success:(void(^)(UIImage *result))success;

/**
 *  加载图片
 *  (图片尺寸：精准提供要求的尺寸；图片质量：质量优先)
 */
- (void)loadOrgImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize success:(void(^)(UIImage *result))success;

/**
 *  加载图片
 */
- (void)loadImageWithAssets:(PHAsset *)asset option:(PHImageRequestOptions *)option success:(void(^)(UIImage *result))success;

/**
 *  加载图片
 */
- (void)loadImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize option:(PHImageRequestOptions *)option success:(void(^)(UIImage *result))success;

@end
