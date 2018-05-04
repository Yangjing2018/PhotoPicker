//
//  AlbumModel.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

- (instancetype)initWithPHAssetCollection:(PHAssetCollection *)collection {
    self = [super init];
    if (self) {
        self.collection = collection;
        self.title = collection.localizedTitle;
        
        PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
        photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.collection options:photosOptions];
        self.photoCount = self.fetchResult.count;
    }
    return self;
}

@end
