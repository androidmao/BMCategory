//
//  BMPopMenuItem.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/23.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "BMPopMenuItem.h"

@implementation BMPopMenuItem

+ (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor image:(NSString *)image {
    
    BMPopMenuItem *menuItem = [[BMPopMenuItem alloc]init];
    [menuItem setTitle:title];
    [menuItem setTitleColor:titleColor];
    [menuItem setImage:image];
    
    BMPopMenuButton *menuButton = [[BMPopMenuButton alloc] init];
    
    CGFloat buttonWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) / 3;
    [menuButton setFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    [menuButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [menuButton setTitle:title forState:UIControlStateNormal];
    [menuButton setTitleColor:titleColor forState:UIControlStateNormal];
    
    [menuItem setMenuButton:menuButton];
    
    return menuItem;
}

@end
