//
//  PhotoListController.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "PhotoListController.h"
#import "PhotoPickerManager.h"
#import "MJRefresh.h"
#import "PhotoListCell.h"

@interface PhotoListController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *albumList;

@property (nonatomic, strong) MJRefreshAutoFooter *refreshFooter;

@end

@implementation PhotoListController {
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.model.title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    _page = 1;
    [self getData];
    [self addSubViews];
}

//MARK: - data
- (void)getData {
    [[PhotoPickerManager manager] photosWithFetch:self.model.fetchResult Page:_page Limit:100 Success:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        if (self.dataArray.count < self.model.photoCount) {
            _page ++;
            [self.refreshFooter endRefreshing];
            
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        
        [self.collectionView reloadData];
    }];
}

//MARK: - private methods
- (void)doneAction {
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)previewAction:(UIButton *)btn {
}

- (void)refreshBottomView {

}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoListCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)addSubViews {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.previewBtn];
    self.previewBtn.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-60-15, CGRectGetHeight([UIScreen mainScreen].bounds)-22-14.5, 60, 22);
    
    [self.view addSubview:self.albumList];
    self.albumList.frame = CGRectMake(15, CGRectGetHeight([UIScreen mainScreen].bounds)-22-14.5, 120, 22);
}


//MARK: - getter
- (MJRefreshAutoFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-52) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.mj_footer = self.refreshFooter;
        [_collectionView registerClass:[PhotoListCell class] forCellWithReuseIdentifier:PhotoListCellID];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)dealloc {
    NSLog(@"yangjing_%@: ", NSStringFromClass([self class]));
}

@end
