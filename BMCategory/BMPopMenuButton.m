//
//  BMPopMenuButton.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/22.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "BMPopMenuButton.h"

@interface BMPopMenuButton ()

@property (nonatomic, copy) AnimationCompletion completion;

@end

@implementation BMPopMenuButton

- (instancetype)init {
    self = [super init];
    if (self) {
        //取消高亮
        self.adjustsImageWhenHighlighted = false;
        
        [self addTarget:self action:@selector(scaleToSmall)
       forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleToDefault)
       forControlEvents:UIControlEventTouchDragExit];

    }
    return self;
}

- (void)scaleToSmall {
    CABasicAnimation* theAnimation;
    theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.2f];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)scaleToDefault {
    CABasicAnimation* theAnimation;
    theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.2f];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag {
    
    CABasicAnimation* cab = (CABasicAnimation*)anim;
    if ([cab.toValue floatValue] == 33.0f || [cab.toValue floatValue] == 1.4f) {
        [self setUserInteractionEnabled:true];
        
        if (self.completion) {
            self.completion();
        }
        
    }
}



//在重新layout子控件时，改变图片和文字的位置
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat imageW = self.frame.size.width / 1.7;
    CGFloat imageX = CGRectGetWidth(self.frame) / 2 - imageW / 2;
    CGFloat imageH = imageW;
    CGFloat imageY = CGRectGetHeight(self.frame) - (imageH + 30);
    [self.imageView setFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    
    CGFloat titleX = 0;
    CGFloat titleH = 20;
    CGFloat titleY = CGRectGetHeight(self.frame) - titleH;
    CGFloat titleW = CGRectGetWidth(self.frame);
    [self.titleLabel setFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
}


- (void)selectedAnimation:(AnimationCompletion)completion {
    
    _completion = completion;
    
    self.userInteractionEnabled = false;
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;

    UIImage* image = self.imageView.image;
    UIColor* color = [UIColor getPixelColorAtLocation:CGPointMake(50, 20) inImage:image];
    [self setBackgroundColor:color];
    
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    
    CABasicAnimation* expandAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnim.fromValue = @(1.0);
    expandAnim.toValue = @(33.0);
    expandAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.95:0.02:1:0.05];
    expandAnim.duration = 0.3;
    expandAnim.delegate = self;
    expandAnim.fillMode = kCAFillModeForwards;
    expandAnim.removedOnCompletion = false;
    expandAnim.autoreverses = NO;
    [self.layer addAnimation:expandAnim forKey:expandAnim.keyPath];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
