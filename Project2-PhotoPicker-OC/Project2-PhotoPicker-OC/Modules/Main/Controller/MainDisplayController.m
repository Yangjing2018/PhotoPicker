//
//  MainDisplayController.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/7/9.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "MainDisplayController.h"
#import "PhotoPickerManager.h"
#import "MainDisplayCell.h"

@interface MainDisplayController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MainDisplayCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation MainDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"显示";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    
    [self addSubview];
}

//MARK: - private methods
- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: - mainDisplayCell delegate
- (void)mainDisplayCell:(MainDisplayCell *)cell didDeletePhoto:(PhotoModel *)model {
    
}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainDisplayCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

//TODO: - 根据图片数量排版
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.dataArray.count == 1) {
//        PhotoModel *model = self.dataArray[indexPath.row];
//        UIImage *image = model.orgImage;
//
//        CGFloat itemWidth = MainDisplayCellWidth;
//
//        return CGSizeZero;
//    }
//
//    else if (self.dataArray.count == 2) {
//        return CGSizeZero;
//    }
//
//    else if (self.dataArray.count == 3) {
//        return CGSizeZero;
//    }
//
//    else if (self.dataArray.count == 4) {
//        return CGSizeZero;
//    }
//
//    else if (self.dataArray.count > 4 ) {
//        CGFloat itemWidth = MainDisplayCellWidth;
//       return CGSizeMake(itemWidth, itemWidth);
//    }
//    return CGSizeZero;
//}

- (void)addSubview {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];

}

//MARK: - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 2;
        _layout.minimumInteritemSpacing = 2;
        
        CGFloat itemWidth = MainDisplayCellWidth;
        _layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds)) collectionViewLayout:self.layout];
        _collectionView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0, CGRectGetHeight([UIScreen mainScreen].bounds)/2.0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainDisplayCell class] forCellWithReuseIdentifier:MainDisplayCellID];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (void)dealloc {
    NSLog(@"yangjing_%@: %s", NSStringFromClass([self class]), __FUNCTION__);
}

@end
