//
//  PhotoListCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#define PhotoListCellID @"PhotoListCellID"

#define PhotoListCellWidth ((CGRectGetWidth([UIScreen mainScreen].bounds)-2*3)/4.0)


@class PhotoListCell;
@protocol PhotoListCellDelegate <NSObject>

- (void)photoListCell:(PhotoListCell *)cell didSelectePhoto:(PhotoModel *)model;

@end

@interface PhotoListCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) NSInteger shouldMask;

@property (nonatomic, weak) id <PhotoListCellDelegate> delegate;

@end
