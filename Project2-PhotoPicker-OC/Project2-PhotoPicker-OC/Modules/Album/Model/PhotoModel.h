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
 *  视频资源
 */
@property (nonatomic, strong) AVAsset *avAsset;

/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *thumImage;

/**
 *  原图
 */
@property (nonatomic, strong) UIImage *orgImage;

/**
 *  选中序号
 *  0 为未选中
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  是否存在iCloud上
 */
@property (nonatomic, assign) BOOL inICloud;

@end
