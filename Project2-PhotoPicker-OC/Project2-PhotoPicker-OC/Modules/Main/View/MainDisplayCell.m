//
//  MainDisplayCell.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/8/21.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "MainDisplayCell.h"
#import "PhotoPickerManager.h"

@interface MainDisplayCell ()

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation MainDisplayCell

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
    
    CGFloat itemWidth = MainDisplayCellWidth;
    CGFloat photoImageWidth = itemWidth-12;

    photoImage.frame = CGRectMake(0, 12, photoImageWidth, photoImageWidth);
    
    CGFloat scale = CGRectGetWidth([UIScreen mainScreen].bounds) == 320 ? 2 : 3;
    [[PhotoPickerManager manager] loadImageWithAssets:model.asset targetSize:CGSizeMake(photoImageWidth*scale, photoImageWidth*scale) success:^(UIImage *result) {
        _model.thumImage = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            photoImage.image = result;
        });
    }];

    self.deleteBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tutor_closemessage"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(photoDeleted:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn;
    });
    [self.contentView addSubview:self.deleteBtn];
    self.deleteBtn.frame = CGRectMake(itemWidth-24, 0, 24, 24);
}

- (void)photoDeleted:(UIButton *)btn {
    if (!self.delegate) return;
    if (![self.delegate respondsToSelector:@selector(mainDisplayCell:didDeletePhoto:)]) return;
    [self.delegate mainDisplayCell:self didDeletePhoto:self.model];
}

- (void)dealloc {
    NSLog(@"yangjing_album: dealloc");
}

@end
