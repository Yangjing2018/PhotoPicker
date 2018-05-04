//
//  VideoListCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#define VideoListCellID @"VideoListCellID"

@interface VideoListCell : UICollectionViewCell

@property (nonatomic, strong) VideoModel *model;

@property (nonatomic, assign) BOOL isSelected;

@end
