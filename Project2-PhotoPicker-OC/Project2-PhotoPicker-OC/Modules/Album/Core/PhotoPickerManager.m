//
//  PhotoPickerManager.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoPickerManager.h"
#import <Photos/Photos.h>

@implementation PhotoPickerManager {
    NSMutableArray *_albumDatasArray;
    PHCachingImageManager *_imageManager;
}

+ (PhotoPickerManager *)manager {
    static PhotoPickerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PhotoPickerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _albumDatasArray = [[NSMutableArray alloc] init];
        _imageManager = [[PHCachingImageManager alloc] init];
        _imageManager.allowsCachingHighQualityImages = YES;
    }
    return self;
}

//相册授权状态
+ (PHAuthorizationStatus)photoLibraryAuthorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

//相册授权
+ (void)photoLibraryAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorization:handler];
}

//获取全部相册
- (void)allAlbumsIfRefresh:(BOOL)refresh success:(void(^)(NSArray <AlbumModel *>*result))success failure:(void(^)(void))failure {
    
    if (!refresh && self.albumArray.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success(self.albumArray);

        });
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_albumDatasArray removeAllObjects];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        //系统相册
        PHFetchResult *systemResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        if (systemResult.count == 0) {
            dispatch_semaphore_signal(semaphore);
        }
        
        [systemResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *collection = (PHAssetCollection *)obj;

            PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
            // 按图片生成时间排序
            photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:photosOptions];
            if (fetchResult.count > 0) {
                AlbumModel *albumModel = [[AlbumModel alloc] init];
                albumModel.title = collection.localizedTitle;
                albumModel.photoCount = fetchResult.count;
                albumModel.collection = collection;
                albumModel.fetchResult = fetchResult;
                [_albumDatasArray addObject:albumModel];
            }

            
            if (idx == _albumDatasArray.count-1) {
                dispatch_semaphore_signal(semaphore);
            }
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        //个人相册
        PHFetchResult *userResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        if (userResult.count == 0) {
            dispatch_semaphore_signal(semaphore);
        }
        [userResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *collection = (PHAssetCollection *)obj;
            PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
            // 按图片生成时间排序
            photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:photosOptions];
            if (fetchResult.count > 0) {
                AlbumModel *albumModel = [[AlbumModel alloc] init];
                albumModel.title = collection.localizedTitle;
                albumModel.photoCount = fetchResult.count;
                albumModel.collection = collection;
                albumModel.fetchResult = fetchResult;
                [_albumDatasArray addObject:albumModel];
            }
            
            if (idx == _albumDatasArray.count-1) {
                dispatch_semaphore_signal(semaphore);
            }
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success(self.albumArray);
        });
    });
}

- (void)photosWithFetch:(PHFetchResult *)fetchResult Page:(NSInteger)page Limit:(NSInteger)limit Success:(void(^)(NSArray *result))success {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSInteger photoCount = limit;
        if (page*limit > fetchResult.count) {
            photoCount = fetchResult.count - ((page-1)*limit);
        }
        
        for (NSInteger i = 0; i < photoCount; i++) {
            PHAsset *asset = [fetchResult objectAtIndex:i+(page-1)*limit];
            if (asset.mediaType == PHAssetMediaTypeImage) {
                PhotoModel *model = [PhotoModel new];
                model.asset = asset;
                model.selected = NO;
                [photos addObject:model];
                
            } else if (asset.mediaType == PHAssetMediaTypeVideo) {
                //                VideoModel *model = [[VideoModel alloc] init];
                //                model.asset = asset;
                //                model.duration = asset.duration;
                //                [photos addObject:model];
                
            }
            if (i == (photoCount-1) && success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(photos);
                });
            }
        }
    });
}

//MARK: - load image
//加载图片(图片尺寸：接近或稍微大于指定尺寸；图片质量：在速度与质量中均衡)
- (void)loadImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize success:(void(^)(UIImage *result))success {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    [self loadImageWithAssets:asset targetSize:targetSize option:option success:success];
}

//加载图片(缩略)(图片尺寸：接近或稍微大于指定尺寸；图片质量：速度优先)
- (void)loadThumImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize success:(void(^)(UIImage *result))success {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [self loadImageWithAssets:asset targetSize:targetSize option:option success:success];
}

//加载图片(原图)(图片尺寸：精准提供要求的尺寸；图片质量：质量优先)
- (void)loadOrgImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize success:(void(^)(UIImage *result))success {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    [self loadImageWithAssets:asset targetSize:targetSize option:option success:success];

}

- (void)loadImageWithAssets:(PHAsset *)asset option:(PHImageRequestOptions *)option success:(void(^)(UIImage *result))success {
    
    [self loadImageWithAssets:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) option:option success:success];
}

- (void)loadImageWithAssets:(PHAsset *)asset targetSize:(CGSize)targetSize option:(PHImageRequestOptions *)option success:(void(^)(UIImage *result))success {
    
    if (targetSize.width == 0 && targetSize.height == 0) {
        targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [_imageManager requestImageForAsset:asset targetSize:targetSize   contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(result);
                
            });
        }];
    });
}

//MARK: - getter
- (NSArray *)albumArray {
    return _albumDatasArray;
}
@end
