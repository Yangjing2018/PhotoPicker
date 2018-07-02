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
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        btn.layer.cornerRadius = 13;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.selected = model.selectedIndex > 0;
        btn;
    });
    [self.contentView addSubview:self.selectedBtn];
    self.selectedBtn.frame = CGRectMake(itemWidth-26-5, 5, 26, 26);
    self.selectedIndex = model.selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    self.model.selectedIndex = selectedIndex;
    self.selectedBtn.selected = selectedIndex > 0;
    
    if (selectedIndex > 0) {
        self.selectedBtn.backgroundColor = [UIColor blueColor];
        self.selectedBtn.layer.borderWidth = 0;
        [self.selectedBtn setTitle:[NSString stringWithFormat:@"%ld", (long)selectedIndex] forState:UIControlStateSelected];
        
        if (_selectedIndex <= 0) {
            self.selectedBtn.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.selectedBtn.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                self.selectedBtn.transform = CGAffineTransformIdentity;
                
            }];
        }

    } else {
        self.selectedBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        self.selectedBtn.layer.borderWidth = 1;
        [self.selectedBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    _selectedIndex = selectedIndex;
}

- (void)photoSelected:(UIButton *)btn {
    if (!self.delegate) return;
    if (![self.delegate respondsToSelector:@selector(photoListCell:didSelectePhoto:)]) return;
    [self.delegate photoListCell:self didSelectePhoto:self.model];
}

- (void)dealloc {
    NSLog(@"yangjing_album: dealloc");
}

@end
