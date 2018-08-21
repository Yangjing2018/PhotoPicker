//
//  MainController.m
//  Project2-PhotoPicker-OC
//
//  Created by YangJing on 2018/3/19.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "MainController.h"
#import "PhotoPickerManager.h"
#import "PhotoPickerController.h"
#import "MainDisplayController.h"

@interface MainController () <PhotoPickerDelegate>

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
    [self presentViewController:[[PhotoPickerController alloc] initWithDelegate:self maxCount:9] animated:YES completion:nil];
    
}

- (void)cameraAction:(id)sender {
    
}

//MARK: - PhotoPickerDelegate
- (void)photoPickerControllerDidCancel:(UIViewController *)picker {}

- (void)photoPickerController:(UIViewController *)picker didFinishPickingPhotos:(NSArray *)photos {
    
    MainDisplayController *subVC = [[MainDisplayController alloc] init];
    subVC.dataArray = [photos mutableCopy];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:subVC] animated:NO completion:nil];
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
