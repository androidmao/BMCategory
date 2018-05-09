//
//  UIUtil.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/9.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "UIUtil.h"
#import "GeneralUtil.h"

@implementation UIUtil

+ (void)showAlertView:(NSString *)title message:(NSString *)message onClickOk:(void(^)(void))onClickOk okTitle:(NSString *)okTitle onClickCancel:(void(^)(void))onClickCancel cancelTitle:(NSString *)cancelTitle{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    ///点击确定
    NSString *okTitleStr = (!okTitle ? @"确定" : okTitle);
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitleStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (onClickOk) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onClickOk();
            });
            
        }
    }];
    ///取消
    NSString *cancelTitleStr = (!cancelTitle ? @"取消" : cancelTitle);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitleStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (onClickCancel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onClickCancel();
            });
        }
    }];
    
    if (okTitle) {
        [alert addAction:okAction];
    }
    
    if (cancelTitle) {
        [alert addAction:cancelAction];
    }
    
    
    [[GeneralUtil getPresentedViewController] presentViewController:alert animated:true completion:nil];
    
}

@end
