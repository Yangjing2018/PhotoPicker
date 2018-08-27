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
    
    CGFloat itemWidth = PhotoListCellWidth;
    photoImage.frame = CGRectMake(0, 0, itemWidth, itemWidth);

    CGFloat scale = CGRectGetWidth([UIScreen mainScreen].bounds) == 320 ? 2 : 3;
    [[PhotoPickerManager manager] loadImageWithAssets:model.asset targetSize:CGSizeMake(itemWidth*scale, itemWidth*scale) success:^(UIImage *result) {
        _model.thumImage = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            photoImage.image = result;
        });
    }];
    
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        UIImageView *playIcon = ({
            UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview-play"]];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view;
        });
        [self.contentView addSubview:playIcon];
        playIcon.frame = CGRectMake(0, 0, itemWidth/4, itemWidth/4);
        playIcon.center = self.contentView.center;
        
        //渐变蒙层
        UIView *durationBackView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            view;
        });
        [self.contentView addSubview:durationBackView];
        durationBackView.frame = CGRectMake(0, itemWidth/3*2, itemWidth, itemWidth/3);
        
        UIColor *color1 = [UIColor colorWithWhite:0 alpha:0];
        UIColor *color2 = [UIColor colorWithWhite:0 alpha:0.2];
        UIColor *color3 = [UIColor colorWithWhite:0 alpha:0.5];
        NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
        NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.4),@(1.0), nil];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = colors;
        gradientLayer.locations = locations;
        gradientLayer.frame = durationBackView.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint   = CGPointMake(0, 1);
        durationBackView.layer.mask = gradientLayer;
        
        UILabel *durationLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentRight;
            label.backgroundColor = [UIColor clearColor];
            label.text = [[NSString alloc] initWithFormat:@"%02ld:%02ld", (long)model.asset.duration/60,  (long)model.asset.duration%60];
            label;
        });
        [self.contentView addSubview:durationLabel];
        durationLabel.frame = CGRectMake(0, itemWidth/3*2, itemWidth-5, itemWidth/3);
    }
    
    if (self.shouldMask && model.selectedIndex <= 0) {
        UIView *coverView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
            view;
        });
        [self.contentView addSubview:coverView];
        coverView.frame = CGRectMake(0, 0, itemWidth, itemWidth);
    }
    
    self.selectedBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        btn.layer.cornerRadius = 12;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.selected = model.selectedIndex > 0;
        btn;
    });
    [self.contentView addSubview:self.selectedBtn];
    self.selectedBtn.frame = CGRectMake(itemWidth-24-5, 6, 24, 24);

    self.selectedBtn.selected = model.selectedIndex > 0;
    
    if (model.selectedIndex > 0) {
        self.selectedBtn.backgroundColor = [UIColor colorWithRed:113/255.0 green:211/255.0 blue:51/255.0 alpha:1];
        self.selectedBtn.layer.borderWidth = 0;
        [self.selectedBtn setTitle:[NSString stringWithFormat:@"%ld", (long)model.selectedIndex] forState:UIControlStateSelected];
        
    } else {
        self.selectedBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.selectedBtn.layer.borderWidth = 1;
        [self.selectedBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    _selectedIndex = model.selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    self.model.selectedIndex = selectedIndex;
    self.selectedBtn.selected = selectedIndex > 0;
    
    if (selectedIndex > 0) {
        self.selectedBtn.backgroundColor = [UIColor colorWithRed:113/255.0 green:211/255.0 blue:51/255.0 alpha:1];
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
        self.selectedBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
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
