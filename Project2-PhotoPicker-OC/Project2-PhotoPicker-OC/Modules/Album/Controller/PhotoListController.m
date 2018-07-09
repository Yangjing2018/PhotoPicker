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
#import "PhotoPerviewController.h"

@interface PhotoListController () <UICollectionViewDelegate, UICollectionViewDataSource, PhotoListCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSMutableArray *selectedCellArray;

@property (nonatomic, strong) UIButton *previewBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) MJRefreshAutoFooter *refreshFooter;

@end

@implementation PhotoListController {
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.model.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    _page = 1;
    [self getData];
    [self addSubViews];
}

//MARK: - data
- (void)getAlbumData {
    
}

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
- (void)doneAction:(UIButton *)btn {
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)previewAction:(UIButton *)btn {
    PhotoPerviewController *subVC = [[PhotoPerviewController alloc] init];
    subVC.selectArray = self.selectedArray;
    subVC.dataArray = self.selectedArray;
    subVC.currentIndex = 0;
    subVC.maxCount = self.maxCount;
    subVC.delegate = self.delegate;
    [self.navigationController pushViewController:subVC animated:YES];
    
}

- (void)refreshBottomView {
    if (self.selectedArray.count > 0) {
        NSString *previewTitle = [NSString stringWithFormat:@"预览(%ld)", (long)self.selectedArray.count];
        [self.previewBtn setTitle:previewTitle forState:UIControlStateNormal];
        CGFloat previewBtnWidth = [previewTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width;
        self.previewBtn.frame = CGRectMake(15, 14.5, previewBtnWidth, 22);

        self.previewBtn.enabled = YES;
        self.confirmBtn.enabled = YES;

    } else {
        self.previewBtn.enabled = NO;
        self.confirmBtn.enabled = NO;

        CGFloat previewBtnWidth = [@"预览" boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width;
        self.previewBtn.frame = CGRectMake(15, 14.5, previewBtnWidth, 22);
    }
}

//MARK: - photoListCellDelegate
- (void)photoListCell:(PhotoListCell *)cell didSelectePhoto:(PhotoModel *)model {
    
    if (cell.selectedIndex > 0) {
        NSInteger currentIndex = 0;
        if ([self.selectedArray containsObject:model]) {
            currentIndex = [self.selectedArray indexOfObject:model];
            [self.selectedArray removeObject:model];
            
        } else {
            NSLog(@"yangjing_%@: data error", NSStringFromClass([self class]));
        }
        
        cell.selectedIndex = 0;
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i = currentIndex, count = self.selectedArray.count; i < count; i++) {
            PhotoModel *selecteModel = self.selectedArray[i];
            selecteModel.selectedIndex = i+1;
            
            if ([self.dataArray containsObject:selecteModel]) {
                NSInteger index = [self.dataArray indexOfObject:selecteModel];
                [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
            }
        }
        if (self.selectedArray.count >= self.maxCount-1) {
            [self.collectionView reloadData];

        } else {
            [self.collectionView reloadItemsAtIndexPaths:indexPaths];

        }
        
    } else {
        if ([self.selectedArray containsObject:model]) {
            NSLog(@"yangjing_%@: data error", NSStringFromClass([self class]));

        } else {
            if (self.selectedArray.count >= self.maxCount) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"一次最多选择%ld张图片", (long)self.maxCount] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
                
            } else {
                [self.selectedArray addObject:model];
                if (self.selectedArray.count >= self.maxCount) {
                    [self.collectionView reloadData];
                }
            }
        }
        
        cell.selectedIndex = self.selectedArray.count;
    }
    
    [self refreshBottomView];
}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoListCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.shouldMask = self.selectedArray.count >= self.maxCount;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPerviewController *subVC = [[PhotoPerviewController alloc] init];
    subVC.selectArray = self.selectedArray;
    subVC.dataArray = self.dataArray;
    subVC.currentIndex = indexPath.row;
    subVC.maxCount = self.maxCount;
    subVC.delegate = self.delegate;
    [self.navigationController pushViewController:subVC animated:YES];
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    UIView *bottomView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        view;
    });
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-52, CGRectGetWidth([UIScreen mainScreen].bounds), 52);
    
    CGFloat previewBtnWidth = [@"预览" boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width;
    [bottomView addSubview:self.previewBtn];
    self.previewBtn.frame = CGRectMake(15, 14.5, previewBtnWidth, 22);
    
    CGFloat confirmWidth = [@"确定" boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width;
    [bottomView addSubview:self.confirmBtn];
    self.confirmBtn.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-confirmWidth-15, 14.5, confirmWidth, 22);
    self.confirmBtn.enabled = NO;
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
        [_previewBtn setTitle:@"预览" forState:UIControlStateDisabled];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _previewBtn.enabled = NO;
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_previewBtn addTarget:self action:@selector(previewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateDisabled];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _confirmBtn.enabled = NO;
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

- (NSMutableArray *)selectedCellArray {
    if (!_selectedCellArray) {
        _selectedCellArray = [[NSMutableArray alloc] init];
    }
    return _selectedCellArray;
}

- (void)dealloc {
    NSLog(@"yangjing_%@: ", NSStringFromClass([self class]));
}

@end
