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

@class PhotoListCell;
@protocol PhotoListCellDelegate <NSObject>

- (void)photoListCell:(PhotoListCell *)cell didSelectePhoto:(PhotoModel *)model;

@end

@interface PhotoListCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id <PhotoListCellDelegate> delegate;

@end
