//
//  AlbumModel.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface AlbumModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger photoCount;

@property (nonatomic, strong) PHFetchResult<PHAsset *> *phFetch;

@end
