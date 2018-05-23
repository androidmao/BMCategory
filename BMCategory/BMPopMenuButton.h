//
//  BMPopMenuButton.h
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/22.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ImageGetColor.h"

typedef void (^AnimationCompletion)(void);

@interface BMPopMenuButton : UIButton<CAAnimationDelegate>

- (void)selectedAnimation:(AnimationCompletion)completion;

@end
