//
//  ViewController.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/4/26.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "ViewController.h"

#import "BMCategory.h"
#import "BMShareView.h"

@interface ViewController ()

@property(nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    [_button setCenter:self.view.center];
    [_button setBackgroundImage:[GeneralUtil createImageByColor:[UIColor grayColor]] forState:UIControlStateNormal];
    
    [self.view addSubview:_button];
    
//    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [_button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    
    
}

- (void)clickAction:(UIButton *)button {
    
//    QRCodeScanViewController *qrCodeScanViewController = [[QRCodeScanViewController alloc]initWithResult:^BOOL(NSString *result) {
//        return NO;
//    }];
//
//    [self presentViewController:qrCodeScanViewController animated:YES completion:nil];
    
//    [UIUtil showAlertView:nil message:@"" onClickOk:^{
//
//    } okTitle:@"" onClickCancel:^{
//
//    } cancelTitle:nil];
    
    

    
    
    [[[BMShareView alloc]initWithResult:^(ShareType shareType) {
        NSLog(@"shareType:%lu",(unsigned long)shareType);
    }] showView:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
