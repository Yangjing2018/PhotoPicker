//
//  VideoCell.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/8/27.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "VideoCell.h"
#import "PhotoPickerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoCell () 

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation VideoCell

- (void)setModel:(PhotoModel *)model {
    _model = model;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    self.player = nil;
    
    self.contentView.backgroundColor = [UIColor blackColor];
    

}

- (void)configPlayer {
    if (self.model.avAsset) {
        
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:self.model.avAsset];
        self.player = [[AVPlayer alloc] initWithPlayerItem:item];
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = self.contentView.bounds;
        [self.contentView.layer addSublayer:playerLayer];
        
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        
        
    } else {
        [[PhotoPickerManager manager] loadVideoWithAssets:self.model.asset progress:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            
        } success:^(AVAsset *asset) {
            
            
            
        } failure:^(NSDictionary *info) {
            
        }];
    }
}

- (void)startPlay {
    [self.player play];

}

- (void)stopPlayer {
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 0)];
}

@end
