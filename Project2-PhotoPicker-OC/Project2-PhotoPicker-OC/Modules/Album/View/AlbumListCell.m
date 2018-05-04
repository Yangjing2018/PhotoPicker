//
//  AlbumListCell.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/5/4.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "AlbumListCell.h"
#import "PhotoPickerManager.h"

@implementation AlbumListCell

- (void)setModel:(AlbumModel *)model {
    _model = model;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = MIN(3, model.photoCount);
    for (NSInteger i = count-1; i >= 0; i--) {
        
        UIImageView *mainImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor lightGrayColor];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        [self.contentView addSubview:mainImageView];
        mainImageView.frame = CGRectMake(10+i*2, 80/2-i*2-60/2, 60-i*4, 60);
        
        CGFloat scale = [UIScreen mainScreen].bounds.size.width == 320 ? 2 : 3;
        [[PhotoPickerManager manager] loadImageWithAssets:[model.fetchResult objectAtIndex:i] targetSize:CGSizeMake((60-i*4)*scale, 60*scale) success:^(UIImage *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                mainImageView.image = result;
            });
        }];
    }
    
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15];
        NSMutableAttributedString *str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%ld)",model.title,(long)model.photoCount]];
        NSInteger titleLength = model.title.length;
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, titleLength)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, titleLength)];
        label.attributedText = str;
        label;
    });
    [self.contentView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(11+10+60, 80/2-20/2, [UIScreen mainScreen].bounds.size.width-11-52-20-5, 20);
}


@end
