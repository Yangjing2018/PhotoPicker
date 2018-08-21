//
//  PhotoThumbnailCell.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/7/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoThumbnailCell.h"
#import "PhotoPickerManager.h"

@interface PhotoThumbnailCell ()

@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation PhotoThumbnailCell

- (void)setModel:(PhotoModel *)model {
    _model = model;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.photoView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [UIColor colorWithRed:113/255.0 green:211/255.0 blue:51/255.0 alpha:1].CGColor;
        imageView.layer.borderWidth = 0;
        imageView;
    });
    [self.contentView addSubview:self.photoView];
    
    CGFloat itemWidth = CGRectGetWidth([UIScreen mainScreen].bounds)/6.0;
    self.photoView.frame = CGRectMake(0, 0, itemWidth, itemWidth);
    
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
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        self.photoView.layer.borderWidth = 2;
        
    } else {
        self.photoView.layer.borderWidth = 0;

    }
}

@end
