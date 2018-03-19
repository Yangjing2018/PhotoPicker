//
//  PhotoPickerDelegate.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoPickerDelegate <NSObject>

/**
 *  完成选择图片
 */
- (void)photoPickerController:(UIViewController *)picker didFinishPickingPhotos:(NSArray *)photos;

/**
 *  取消
 */
- (void)photoPickerControllerDidCancel:(UIViewController *)picker;

@end
