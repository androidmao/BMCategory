//
//  BMShareView.h
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/11.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMShareButton.h"

typedef NS_ENUM(NSUInteger, ShareType) {
    ///微信
    ShareType_WX,
    ///微信朋友圈
    ShareType_WX_PYQ,
    ///QQ
    ShareType_QQ,
    ///QQ空间
    ShareType_QQ_ZONE,
    ///新浪微博
    ShareType_SINA,
    ///腾讯微博
    ShareType_TENCENT,
};

/**
 选中分享回调函数

 @param shareType 分享类型
 */
typedef void(^SelectedShareTypeCompletion)(ShareType shareType);

@interface BMShareView : UIView

- (instancetype)initWithResult:(SelectedShareTypeCompletion)selectedShareTypeCompletion;

- (void)showView:(BOOL)animated;

- (void)dismissView:(BOOL)animated;

@end
