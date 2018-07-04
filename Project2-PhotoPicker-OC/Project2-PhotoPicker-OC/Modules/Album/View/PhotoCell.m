//
//  PhotoCell.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoPickerManager.h"

@interface PhotoCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UIScrollView *backScrollView;

@end

@implementation PhotoCell

- (void)setModel:(PhotoModel *)model {
    _model = model;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    _backScrollView.backgroundColor = [UIColor blackColor];
    _backScrollView.delegate = self;
    _backScrollView.maximumZoomScale = 2;
    [_backScrollView setZoomScale:1 animated:NO];
    _backScrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    [self.contentView addSubview:_backScrollView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    tap1.numberOfTapsRequired = 1;
    [_backScrollView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomScaleAction:)];
    tap2.numberOfTapsRequired = 2;
    [_backScrollView addGestureRecognizer:tap2];

    //当单击操作遇到了 双击 操作时，单击失效
    [tap1 requireGestureRecognizerToFail:tap2];
    
    _photoView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView;
    });
    [_backScrollView addSubview:_photoView];
    _photoView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    
    if (model.thumImage) {
        _photoView.image = model.thumImage;
        
    } else {
        _photoView.image = [UIImage imageNamed:@"default_pic"];
    }
    
    if (model.orgImage) {
        _photoView.image = model.orgImage;
        
    } else if (model.asset) {
        
        [[PhotoPickerManager manager] loadOrgImageWithAssets:model.asset targetSize:CGSizeZero success:^(UIImage *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                model.orgImage = result;
                _photoView.image = result;

            });
        }];
    }
}

- (void)setCellZoomScale:(CGFloat)zoomScale animated:(BOOL)animated {
    [_backScrollView setZoomScale:zoomScale animated:animated];

}

- (void)zoomScaleAction:(UITapGestureRecognizer *)tap {
    if (_backScrollView.zoomScale > 1) {
        [_backScrollView setZoomScale:1 animated:YES];
        
    } else {
        [_backScrollView setZoomScale:2 animated:YES];

    }
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (!self.delegate) return;
    if (![self.delegate respondsToSelector:@selector(photoCell:singleTapAction:)]) return;
    [self.delegate photoCell:self singleTapAction:tap];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoView;
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;

    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _photoView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)photoSelected:(UIButton *)btn {
 
}

- (void)setIsSelectedPhoto:(BOOL)isSelectedPhoto {

}

- (void)dealloc {
    NSLog(@"yangjing_album: dealloc");
}

@end
