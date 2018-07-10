//
//  MainDisplayView.h
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/7/9.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@class MainDisplayView;
@protocol MainDisplayViewDelegate <NSObject>

- (void)mainDisplayView:(MainDisplayView *)view didSelected:(PhotoModel *)model;

- (void)mainDisplayView:(MainDisplayView *)view didDelete:(PhotoModel *)model;

@end

@interface MainDisplayView : UIView

@property (nonatomic, weak) id <MainDisplayViewDelegate> delegate;

@property (nonatomic, strong) PhotoModel *model;

@end
