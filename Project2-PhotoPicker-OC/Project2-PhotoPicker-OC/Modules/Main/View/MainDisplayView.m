//
//  MainDisplayView.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/7/9.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "MainDisplayView.h"
#import "PhotoPickerManager.h"

@interface MainDisplayView ()

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation MainDisplayView

- (void)setModel:(PhotoModel *)model {
    _model = model;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.photoView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [UIColor greenColor].CGColor;
        imageView.layer.borderWidth = 0;
        imageView;
    });
    [self addSubview:self.photoView];
    self.photoView.frame = self.bounds;
    
    if (model.thumImage) {
        self.photoView.image = model.thumImage;
        
    } else {
        self.photoView.image = [UIImage imageNamed:@"default_pic"];
    }
    
    if (model.orgImage) {
        self.photoView.image = model.orgImage;
        
    } else if (model.asset) {
        
        [[PhotoPickerManager manager] loadOrgImageWithAssets:model.asset targetSize:CGSizeZero success:^(UIImage *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                model.orgImage = result;
                self.photoView.image = result;
                
            });
        }];
    }
    
    self.deleteBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tutor_closemessage"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:self.deleteBtn];
    self.deleteBtn.frame = CGRectMake(CGRectGetMaxX(self.frame)-42, 0, 42, 42);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)deleteAction:(id)sender {
    if (!self.delegate) return;
    if (![self.delegate respondsToSelector:@selector(mainDisplayView:didDelete:)]) return;
    [self.delegate mainDisplayView:self didDelete:self.model];
}

- (void)tapAction:(id)sender {
    if (!self.delegate) return;
    if (![self.delegate respondsToSelector:@selector(mainDisplayView:didSelected:)]) return;
    [self.delegate mainDisplayView:self didSelected:self.model];
}

@end
