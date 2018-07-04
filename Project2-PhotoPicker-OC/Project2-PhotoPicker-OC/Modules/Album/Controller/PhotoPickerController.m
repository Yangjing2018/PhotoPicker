//
//  PhotoPickerController.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoPickerController.h"
#import "AlbumListController.h"

@interface PhotoPickerController ()

@end

@implementation PhotoPickerController

- (instancetype)initWithDelegate:(id<PhotoPickerDelegate>)delegate maxCount:(NSInteger)maxCount {
    AlbumListController *albumVC = [[AlbumListController alloc] initWithDelegate:delegate maxCount:maxCount];
    return [super initWithRootViewController:albumVC];
}

@end
