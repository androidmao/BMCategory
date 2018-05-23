//
//  BMPopMenuView.h
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/22.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMPopMenuItem.h"

@class BMPopMenuView;

@protocol BMPopMenuViewDelegate <NSObject>

- (void)popMenuView:(BMPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index;

@end

@interface BMPopMenuView : UIView


@property (nonatomic, weak) id<BMPopMenuViewDelegate> delegate;

@property (nonatomic, strong) NSArray<BMPopMenuItem *> *items;


- (void)showPopMenuItem;

- (void)dismissPopMenuItem;


@end
