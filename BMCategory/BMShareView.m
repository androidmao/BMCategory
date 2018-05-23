//
//  BMShareView.m
//  BMCategoryExample
//
//  Created by BlackCoffee on 2018/5/11.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "BMShareView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight (SCREEN_H == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_H == 812.0 ? 34 : 0)

#define BMShareBundle [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"BMShareBundle" ofType:@"bundle"]]

//弹窗高度
#define ContentView_H 260

@interface BMShareView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) NSMutableArray<BMShareButton *> *buttons;

@property(nonatomic, copy) SelectedShareTypeCompletion selectedShareTypeCompletion;

@end

@implementation BMShareView


- (instancetype)initWithResult:(SelectedShareTypeCompletion)selectedShareTypeCompletion {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    if (self) {
        _selectedShareTypeCompletion = selectedShareTypeCompletion;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.contentView addSubview:self.scrollView];
    
    [self.contentView addSubview:self.cancelButton];
    
    [self addSubview:self.contentView];
    
    NSArray<NSDictionary *> *shareArray = @[
          @{@"share_type":@(ShareType_WX),@"share_title":@"微信好友",@"share_img":@"weixin_allshare_60x60_"},
          @{@"share_type":@(ShareType_WX_PYQ),@"share_title":@"微信朋友圈",@"share_img":@"pyq_allshare_60x60_"},
          @{@"share_type":@(ShareType_QQ),@"share_title":@"手机QQ",@"share_img":@"qq_allshare_60x60_"},
          @{@"share_type":@(ShareType_QQ_ZONE),@"share_title":@"QQ空间",@"share_img":@"qqkj_allshare_60x60_"},
          @{@"share_type":@(ShareType_SINA),@"share_title":@"新浪微博",@"share_img":@"sina_allshare_60x60_"},
          @{@"share_type":@(ShareType_TENCENT),@"share_title":@"腾讯微博",@"share_img":@"qqwb_allshare_60x60_"}];
    
    
    _buttons = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < shareArray.count; i++) {
        
        NSNumber *shareType = [[shareArray objectAtIndex:i] objectForKey:@"share_type"];
        NSString *shareTitle = [[shareArray objectAtIndex:i] objectForKey:@"share_title"];
        NSString *shareImg = [[shareArray objectAtIndex:i] objectForKey:@"share_img"];
        
        BMShareButton *button = [[BMShareButton alloc]initWithFrame:CGRectMake(10 * (i + 1) + i * 70, 20, 70, 90)];

        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:shareTitle forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageWithContentsOfFile:[BMShareBundle pathForResource:[NSString stringWithFormat:@"%@@2x",shareImg] ofType:@"png"]] forState:UIControlStateNormal];
        
        [button setTag:[shareType unsignedIntegerValue]];
        
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        
        [_buttons addObject:button];
    }
    
    
    [self.scrollView setContentSize:CGSizeMake(80 * shareArray.count + 10, 110)];
    
}

- (UITapGestureRecognizer *)tapGestureRecognizer{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        [_tapGestureRecognizer setCancelsTouchesInView:YES];
        [_tapGestureRecognizer setDelegate:self];
    }
    return _tapGestureRecognizer;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self) {
        
        return YES;
    }
    return NO;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    
    [self dismissView:YES];
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, ContentView_H)];
        
        [_contentView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]];
        // 阴影透明度
        _contentView.layer.shadowOpacity = 0.5;
        // 阴影的颜色
        _contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        // 阴影的范围
        _contentView.layer.shadowOffset = CGSizeMake(1, 1);
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 110)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ContentView_H - 50, SCREEN_W, 50)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self createImageByColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self createImageByColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0, 0, SCREEN_W, 0.5);
        
        bottomBorder.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0].CGColor;
        
        [_cancelButton.layer addSublayer:bottomBorder];
        
        [_cancelButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)clickAction:(UIButton *)button {
    
    if (button == self.cancelButton) {
        [self dismissView:YES];
    } else if ([button isKindOfClass:[BMShareButton class]]) {
        if (self.selectedShareTypeCompletion) {
            self.selectedShareTypeCompletion(button.tag);
        }
        [self dismissView:YES];
    }
    
}

- (void)showView:(BOOL)animated {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [self.contentView setFrame:CGRectMake(0, SCREEN_H - ContentView_H, SCREEN_W, ContentView_H)];
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    [UIView commitAnimations];
    
    
    for (int i = 0; i < _buttons.count; i++) {

        UIButton *button = [_buttons objectAtIndex:i];

        button.transform = CGAffineTransformMakeTranslation(0, 150);

        [UIView animateWithDuration:0.8 delay:i * 0.05 usingSpringWithDamping:0.7 initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

        }];

    }
    
}

- (void)dismissView:(BOOL)animated {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         [self.contentView setFrame:CGRectMake(0, SCREEN_H, SCREEN_W, ContentView_H)];
                         [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
    
}



/**
 颜色转图片

 @param color color 颜色
 @return return value
 */
- (UIImage *)createImageByColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
