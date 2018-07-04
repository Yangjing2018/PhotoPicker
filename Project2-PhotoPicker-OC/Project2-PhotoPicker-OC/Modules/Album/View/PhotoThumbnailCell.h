//
//  PhotoThumbnailCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/7/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#define PhotoThumbnailCellID @"PhotoThumbnailCellID"

@interface PhotoThumbnailCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, assign) BOOL isSelected;

@end
