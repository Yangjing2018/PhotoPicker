//
//  PhotoPickerController.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPickerDelegate.h"

@interface PhotoPickerController : UINavigationController

/**
 *  初始化
 *  delegate ： 代理
 *  maxCount ： 最多可选择相片数
 */
- (instancetype)initWithDelegate:(id<PhotoPickerDelegate>)delegate maxCount:(NSInteger)maxCount;

@end
