//
//  ViewController.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/4/26.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "ViewController.h"

#import "GeneralUtil.h"

#import "QRCodeScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    [button setCenter:self.view.center];
    [button setBackgroundImage:[GeneralUtil createImageByColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    
    
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)clickAction:(UIButton *)button {
    
    QRCodeScanViewController *qrCodeScanViewController = [[QRCodeScanViewController alloc]initWithResult:^BOOL(NSString *result) {
        return NO;
    }];
    
    [self presentViewController:qrCodeScanViewController animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
