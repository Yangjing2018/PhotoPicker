//
//  PhotoListCell.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoListCell.h"
#import "PhotoPickerManager.h"

@interface PhotoListCell ()

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation PhotoListCell

- (void)setModel:(PhotoModel *)model {
    _model = model;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *photoImage = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [self.contentView addSubview:photoImage];
    
    CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds)-2*3)/4.0;
    photoImage.frame = CGRectMake(0, 0, itemWidth, itemWidth);

    CGFloat scale = CGRectGetWidth([UIScreen mainScreen].bounds) == 320 ? 2 : 3;
    [[PhotoPickerManager manager] loadImageWithAssets:model.asset targetSize:CGSizeMake(itemWidth*scale, itemWidth*scale) success:^(UIImage *result) {
        _model.thumImage = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            photoImage.image = result;
        });
    }];
    
    self.selectedBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        btn.selected = model.selected;
        btn;
    });
    [self.contentView addSubview:self.selectedBtn];
    self.selectedBtn.frame = CGRectMake(itemWidth-26-5, 5, 26, 26);
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _model.selected = !_model.selected;
    self.selectedBtn.selected = !self.selectedBtn.selected;
    
    if (!_model.selected) {
        _model.orgImage = nil;
        return;
    }
    
//    [[AlbumManager manager] loadImageWithAssets:_model.asset maxSize:CGSizeMake(kScreenWidth, kScreenHeight) Success:^(UIImage *result) {
//        _model.orgImage = [UIImage thumbnailImage:result maxSize:CGSizeMake(kScreenWidth, kScreenHeight)];
//    }];
}

- (void)photoSelected:(UIButton *)btn {
//    if (!self.delegate) return;
//    if (![self.delegate respondsToSelector:@selector(photoCell:didSelected:)]) return;
//    [self.delegate photoCell:self didSelected:_model];
}

- (void)dealloc {
    NSLog(@"yangjing_album: dealloc");
}

@end
