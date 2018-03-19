//
//  MainController.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "MainController.h"
#import "PhotoPickerManager.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"PhotoPicker";
}

//MARK: - private methods
- (void)albumAction:(id)sender {
    [[PhotoPickerManager manager] allAlbumsSuccess:^(NSArray<AlbumModel *> *result) {
        
    }];
}

- (void)cameraAction:(id)sender {
    
}

- (void)addSubView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *albumBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"相册" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 50;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 1);
        btn.layer.shadowOpacity = 0.2;
        btn.layer.shadowRadius = 4;
        [btn addTarget:self action:@selector(albumAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:albumBtn];
    albumBtn.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2-50, 150, 100, 100);
    
    UIButton *cameraBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"相机" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 50;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 1);
        btn.layer.shadowOpacity = 0.2;
        btn.layer.shadowRadius = 4;
        [btn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:cameraBtn];
    cameraBtn.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2-50, 350, 100, 100);
}

@end
