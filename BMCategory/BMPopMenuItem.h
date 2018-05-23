//
//  BMPopMenuItem.h
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/23.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMPopMenuButton.h"

@interface BMPopMenuItem : NSObject


@property (nonatomic, strong, nonnull) NSString *title;

@property (nonatomic, strong, nonnull) UIColor *titleColor;

@property (nonatomic, strong, nonnull) NSString *image;

@property (nonatomic, strong, nonnull) BMPopMenuButton *menuButton;

+ (instancetype _Nonnull )initWithTitle:(NSString *_Nonnull)title titleColor:(UIColor *_Nonnull)titleColor image:(NSString *_Nonnull)image;

@end
