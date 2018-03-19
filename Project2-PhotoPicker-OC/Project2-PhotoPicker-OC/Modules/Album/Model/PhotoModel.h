//
//  PhotoModel.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoModel : NSObject

/**
 *  相片资源
 */
@property (nonatomic, strong) PHAsset *asset;

/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *thumImage;

/**
 *  原图
 */
@property (nonatomic, strong) UIImage *orgImage;

/**
 *  是否选中
 */
@property (nonatomic, assign) BOOL selected;

@end
