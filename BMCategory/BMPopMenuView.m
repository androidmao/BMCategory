//
//  BMPopMenuView.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/22.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "BMPopMenuView.h"

@interface BMPopMenuView ()

//毛玻璃效果背景
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation BMPopMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    if (self) {
        [self.visualEffectView setFrame:self.frame];
        [self addSubview:self.visualEffectView];
        [self.visualEffectView setAlpha:0];
        [self addSubview:self.closeButton];
    }
    return self;
}



- (UIVisualEffectView *)visualEffectView {
    if (!_visualEffectView) {
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    }
    return _visualEffectView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 70, 20, 50, 50)];
        [_closeButton setImage:[UIImage imageNamed:@"comm_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)setItems:(NSArray<BMPopMenuItem *> *)items {
    
    _items = items;
    
    [_items enumerateObjectsUsingBlock:^(BMPopMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat S_H = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat W = CGRectGetWidth(obj.menuButton.frame);
        
        CGFloat X = (idx % 3) * W;
        CGFloat Y = (idx / 3) * W + (S_H - W * 2)/2;
        
        [obj.menuButton setFrame:CGRectMake(X, Y, W, W)];
        
        [obj.menuButton setTag:idx];
        
        [obj.menuButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:obj.menuButton];
        
        
    }];
    
    
}

- (void)showPopMenuItem {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self.items enumerateObjectsUsingBlock:^(BMPopMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.menuButton.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(obj.menuButton.frame));
        
        [UIView animateWithDuration:0.8 delay:(self.items.count - idx) * 0.05 usingSpringWithDamping:0.7 initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            obj.menuButton.transform = CGAffineTransformIdentity;
            
            if (idx == self.items.count - 1) {
                [self.visualEffectView setAlpha:0.8];
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}

- (void)dismissPopMenuItem {
    
    [self.closeButton setEnabled:NO];
    
    [self.items enumerateObjectsUsingBlock:^(BMPopMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.menuButton.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.8 delay:idx * 0.05 usingSpringWithDamping:0.7 initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGFloat SCR_H = CGRectGetHeight([UIScreen mainScreen].bounds);
            
            obj.menuButton.transform = CGAffineTransformMakeTranslation(0, -(((self.items.count - idx - 1) / 3 + 2) * CGRectGetWidth(obj.menuButton.frame) + (SCR_H - CGRectGetWidth(obj.menuButton.frame) * 2)/2));
            
            if (idx == self.items.count - 1) {
                [self.visualEffectView setAlpha:0];
            }
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }];
    
}


- (void)clickAction:(UIButton *)button {
    
    if (button == self.closeButton) {
        
        [self dismissPopMenuItem];
        
    } else {
        
        [(BMPopMenuButton *)button selectedAnimation:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(popMenuView:didSelectItemAtIndex:)]) {
                [self.delegate popMenuView:self didSelectItemAtIndex:button.tag];
                [self removeFromSuperview];
            }
        }];
        
    }
    
}



@end
