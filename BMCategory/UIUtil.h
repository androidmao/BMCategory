//
//  UIUtil.h
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/9.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtil : NSObject

/**
 弹出框

 @param title 标题
 @param message 内容
 @param onClickOk 点击确认回调
 @param okTitle 确认按钮标题
 @param onClickCancel 点击取消回调
 @param cancelTitle 取消按钮标题
 */
+ (void)showAlertView:(NSString *)title message:(NSString *)message onClickOk:(void(^)(void))onClickOk okTitle:(NSString *)okTitle onClickCancel:(void(^)(void))onClickCancel cancelTitle:(NSString *)cancelTitle;

@end
