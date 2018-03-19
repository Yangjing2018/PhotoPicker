//
//  VideoModel.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface VideoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) UIImage *orgSnapImage;

@property (nonatomic, strong) UIImage *thumSnapImage;

@property (nonatomic, assign) long duration;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) NSURL *localUrl;

@end
