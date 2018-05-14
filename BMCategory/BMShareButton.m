//
//  BMShareButton.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/11.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "BMShareButton.h"

@implementation BMShareButton



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//在重新layout子控件时，改变图片和文字的位置
- (void)layoutSubviews {
    [super layoutSubviews];
    // 图片上限靠着button的顶部
    CGRect tempImageviewRect = self.imageView.frame;
    tempImageviewRect.origin.y = 5;
    // 图片左右居中，也就是x坐标为button宽度的一半减去图片的宽度
    tempImageviewRect.origin.x = 5;
    tempImageviewRect.size.width = self.bounds.size.width - 10;
    tempImageviewRect.size.height = self.bounds.size.width - 10;
    self.imageView.frame = tempImageviewRect;

    CGRect tempLabelRect = self.titleLabel.frame;
    // 文字label的x靠着button左侧(或距离多少)
    tempLabelRect.origin.x = 0;
    // y靠着图片的下部
    tempLabelRect.origin.y = self.bounds.size.height - tempLabelRect.size.height;
    
    // 宽度与button一致，或者自己改
    tempLabelRect.size.width = self.bounds.size.width;
    //    // 高度等于button高度减去上方图片高度
    //    tempLabelRect.size.height = self.bounds.size.height - self.imageView.frame.size.height;
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.titleLabel.frame = tempLabelRect;
}

@end
