//
//  PhotoCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#define PhotoCellID @"PhotoCellID"

@class PhotoCell;
@protocol PhotoCellDelegate <NSObject>

- (void)photoCell:(PhotoCell *)cell singleTapAction:(UITapGestureRecognizer *)tap;

@end

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id <PhotoCellDelegate> delegate;

- (void)setCellZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;

@end
