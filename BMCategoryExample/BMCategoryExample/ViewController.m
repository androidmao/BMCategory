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
#import "BMPopMenuView.h"

@interface ViewController ()<BMPopMenuViewDelegate>

@property(nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     _button = [[UIButton alloc]initWithFrame:CGRectMake(300, 20, 80, 50)];
//    [_button setCenter:self.view.center];
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
    
    
    BMPopMenuItem *item1 = [BMPopMenuItem initWithTitle:@"手机联系人" titleColor:[UIColor lightGrayColor] image:@"comm_contact"];
    BMPopMenuItem *item2 = [BMPopMenuItem initWithTitle:@"扫一扫" titleColor:[UIColor lightGrayColor] image:@"comm_scan"];
    BMPopMenuItem *item3 = [BMPopMenuItem initWithTitle:@"添加员工" titleColor:[UIColor lightGrayColor] image:@"comm_add"];
    BMPopMenuItem *item4 = [BMPopMenuItem initWithTitle:@"邀请员工" titleColor:[UIColor lightGrayColor] image:@"comm_invite"];
    
    
    BMPopMenuView *view = [[BMPopMenuView alloc]init];
    [view setDelegate:self];
    [view setItems:@[item1,item2,item3,item4]];

    [view showPopMenuItem];
    
//    [[[BMShareView alloc]initWithResult:^(ShareType shareType) {
//        NSLog(@"shareType:%lu",(unsigned long)shareType);
//    }] showView:YES];
    
}

- (void)popMenuView:(BMPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
