//
//  PhotoListController.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoListController.h"
#import "MJRefresh.h"

@interface PhotoListController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *albumList;

@property (nonatomic, strong) MJRefreshAutoFooter *refreshFooter;

@end

@implementation PhotoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//MARK: - getter
- (MJRefreshAutoFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:nil];
    }
    return _refreshFooter;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 2;
        _layout.minimumInteritemSpacing = 2;
        CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds)-2*3)/4.0;
        _layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.mj_footer = self.refreshFooter;
        
    }
    return _collectionView;
}

- (UIButton *)previewBtn {
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _previewBtn.alpha = 0.6;
        _previewBtn.enabled = NO;
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_previewBtn addTarget:self action:@selector(previewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

- (UIButton *)albumList {
    if (!_albumList) {
        _albumList = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumList setTitle:@"选择相册" forState:UIControlStateNormal];
        [_albumList setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _albumList.enabled = YES;
        _albumList.titleLabel.font = [UIFont systemFontOfSize:16];
        [_albumList addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumList;
}

- (void)dealloc {
}

@end
