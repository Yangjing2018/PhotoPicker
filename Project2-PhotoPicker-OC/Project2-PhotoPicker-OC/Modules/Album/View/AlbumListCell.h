//
//  AlbumListCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#define AlbumListCellID     @"AlbumListCellID"

@interface AlbumListCell : UITableViewCell

@property (nonatomic, strong) AlbumModel *model;

@end
