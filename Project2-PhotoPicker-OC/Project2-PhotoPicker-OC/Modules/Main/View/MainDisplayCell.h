//
//  MainDisplayCell.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/8/21.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#define MainDisplayCellID       @"MainDisplayCellID"
#define MainDisplayCellWidth    ((CGRectGetWidth([UIScreen mainScreen].bounds)-2*2-4)/3.0)

@class MainDisplayCell;
@protocol MainDisplayCellDelegate <NSObject>

- (void)mainDisplayCell:(MainDisplayCell *)cell didDeletePhoto:(PhotoModel *)model;

@end

@interface MainDisplayCell : UICollectionViewCell

@property (nonatomic, strong) PhotoModel *model;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id <MainDisplayCellDelegate> delegate;

@end
