//
//  VideoCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/8/27.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#define VideoCellID @"VideoCellID"

@class VideoCell;
@protocol VideoCellDelegate <NSObject>

- (void)videoCell:(VideoCell *)cell singleTapAction:(UITapGestureRecognizer *)tap;

@end

@interface VideoCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id <VideoCellDelegate> delegate;

- (void)stopPlayer;

@end
