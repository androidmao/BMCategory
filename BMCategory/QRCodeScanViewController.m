//
//  QRCodeScanViewController.m
//  AnXinClient
//
//  Created by GOKIT on 2018/2/26.
//  Copyright © 2018年 AnXin. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Masonry.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight (SCREEN_H == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_H == 812.0 ? 34 : 0)

@interface QRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDeviceInput *input;
@property(nonatomic, strong) AVCaptureMetadataOutput *output;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic, assign) CGRect interestRect;

@property(nonatomic,strong) UIImageView *qrcodeBackgroundImageView;

@property(nonatomic,strong) UIImageView *scanningImageView;

@property(nonatomic,strong) UIButton *closeButton;
@property(nonatomic,strong) UIButton *lightSwitchButton;

@end

@implementation QRCodeScanViewController


- (void)opentAVCaptureSession {

    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    NSError *inputError = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&inputError];
    if (inputError) {
        NSLog(@"AVCaptureDeviceInput Error:%@",inputError.localizedDescription);
    }

    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];


    //设置扫描区域
    CGSize size = self.view.bounds.size;
    CGRect cropRect = CGRectMake(60,(SCREEN_H - (SCREEN_W - 120))/2,SCREEN_W - 120,SCREEN_W - 120);
    self.output.rectOfInterest = CGRectMake(cropRect.origin.y/SCREEN_H,
                                            cropRect.origin.x/size.width,
                                            cropRect.size.height/size.height,
                                            cropRect.size.width/size.width);


    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //闪光灯
    AVCaptureVideoDataOutput *lightOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [lightOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    [self.session addOutput:lightOutput];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];


    self.videoLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.videoLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.videoLayer above:0];

    [self.session startRunning];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil) {
        
        CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
        
        NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
        
        CFRelease(metadataDict);
        
        NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
        
        float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
        
        
        // 根据brightnessValue的值来打开和关闭闪光灯
        if ((brightnessValue < 0)) {
            // 显示打开闪光灯按钮，打开闪光灯
            [self.lightSwitchButton setHidden:NO];
        } else {
            
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
            
            //闪光灯开启状态
            if([device hasTorch] && device.torchMode == AVCaptureTorchModeOn &&
               device.flashMode == AVCaptureFlashModeOn) {
                // 显示打开闪光灯按钮，打开闪光灯
                [self.lightSwitchButton setHidden:NO];
            } else {
                // 隐藏打开闪光灯按钮，关闭闪光灯
                [self.lightSwitchButton setHidden:YES];
            }
            
            
        }
        
    }

}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self.session stopRunning];
    [self.scanningImageView setHidden:YES];
    [self openShake:NO Sound:YES];
    //[self.backgroundView invalidateTimer];
    AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
    NSLog(@"%@",metadataObject.corners);
    NSLog(@"%@",metadataObject.stringValue);
    
     NSString *transString = [NSString stringWithString:[metadataObject.stringValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
    if (self.qrCodeScanCompletion) {
        
        if (self.qrCodeScanCompletion(transString)) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.session startRunning];
            [self.scanningImageView setHidden:NO];
        }
        
    }
            
       

}

- (void)openLight:(BOOL)opened {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    if (![device hasTorch]) {
    } else {
        if (opened) {
            // 开启闪光灯
            if(device.torchMode != AVCaptureTorchModeOn ||
               device.flashMode != AVCaptureFlashModeOn){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                [device unlockForConfiguration];
            }
        } else {
            // 关闭闪光灯
            if(device.torchMode != AVCaptureTorchModeOff ||
               device.flashMode != AVCaptureFlashModeOff){
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                [device unlockForConfiguration];
            }
        }
    }
}

- (void)openShake:(BOOL)shaked Sound:(BOOL)sounding {
    if (shaked) {
        //开启系统震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (sounding) {
        //设置自定义声音
        SystemSoundID soundID;
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"QRCodeBundle" ofType:@"bundle"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[bundle pathForResource:@"qrcode_ring" ofType:@"wav"]], &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

- (UIImageView *)qrcodeBackgroundImageView {
    if (!_qrcodeBackgroundImageView) {
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"QRCodeBundle" ofType:@"bundle"]];
        
        
        _qrcodeBackgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"image_qrcode_background@2x" ofType:@"png"]]];
        [_qrcodeBackgroundImageView setUserInteractionEnabled:YES];
        [_qrcodeBackgroundImageView.layer setBorderColor:[UIColor greenColor].CGColor];
        [_qrcodeBackgroundImageView.layer setBorderWidth:0.5];

        UIImageView *qrcodeTopLeftImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_qrcode_top_left@2x" ofType:@"png"]]];

        UIImageView *qrcodeTopRightImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_qrcode_top_right@2x" ofType:@"png"]]];

        UIImageView *qrcodeBottomLeftImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_qrcode_bottom_left@2x" ofType:@"png"]]];

        UIImageView *qrcodeBottomRightImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_qrcode_bottom_right@2x" ofType:@"png"]]];

        [_qrcodeBackgroundImageView addSubview:qrcodeTopLeftImageView];
        [_qrcodeBackgroundImageView addSubview:qrcodeTopRightImageView];
        [_qrcodeBackgroundImageView addSubview:qrcodeBottomLeftImageView];
        [_qrcodeBackgroundImageView addSubview:qrcodeBottomRightImageView];

        [qrcodeTopLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qrcodeBackgroundImageView).mas_offset(-1);
            make.left.equalTo(self.qrcodeBackgroundImageView).mas_offset(-1);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

        [qrcodeTopRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qrcodeBackgroundImageView).mas_offset(-1);
            make.right.equalTo(self.qrcodeBackgroundImageView).mas_offset(1);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

        [qrcodeBottomLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.qrcodeBackgroundImageView).mas_offset(3);
            make.left.equalTo(self.qrcodeBackgroundImageView).mas_offset(-1);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

        [qrcodeBottomRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.qrcodeBackgroundImageView).mas_offset(3);
            make.right.equalTo(self.qrcodeBackgroundImageView).mas_offset(1);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

    }
    return _qrcodeBackgroundImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(QRCodeScanAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)lightSwitchButton {
    if (!_lightSwitchButton) {
        _lightSwitchButton = [[UIButton alloc]init];
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"QRCodeBundle" ofType:@"bundle"]];
        [_lightSwitchButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_light_normal@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [_lightSwitchButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_light_highlighted@2x" ofType:@"png"]] forState:UIControlStateSelected];
        [_lightSwitchButton addTarget:self action:@selector(QRCodeScanAction:) forControlEvents:UIControlEventTouchUpInside];
        [_lightSwitchButton setHidden:YES];
    }
    return _lightSwitchButton;
}

- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {
        _scanningImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W - 120, (SCREEN_W - 120) * 0.0375)];
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"QRCodeBundle" ofType:@"bundle"]];
        [_scanningImageView setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"qrcode_scan_weixin_Line@2x" ofType:@"png"]]];
        [_scanningImageView setHidden:YES];
    }
    return _scanningImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self opentAVCaptureSession];

    UIView *topView = [[UIView alloc]init];
    [topView setBackgroundColor:[UIColor blackColor]];
    [topView setAlpha:0.8];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(SafeAreaTopHeight);
    }];


    [topView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView);
        make.left.equalTo(topView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
    }];

    [self.view addSubview:self.qrcodeBackgroundImageView];

    [self.qrcodeBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];

    [self.qrcodeBackgroundImageView addSubview:self.lightSwitchButton];

    [self.lightSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeBackgroundImageView);
        make.bottom.equalTo(self.qrcodeBackgroundImageView).mas_offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];

    [self.qrcodeBackgroundImageView addSubview:self.scanningImageView];
    
}


- (void)QRCodeScanAction:(UIButton *)button {
    
    if (button == self.closeButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (button == self.lightSwitchButton) {
        if (self.lightSwitchButton.isSelected) {
            [self.lightSwitchButton setSelected:NO];
            [self openLight:NO];
        } else {
            [self.lightSwitchButton setSelected:YES];
            [self openLight:YES];
        }
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    //扫描框缩放动画
    [self.qrcodeBackgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_W - 120);
        make.height.mas_equalTo(SCREEN_W - 120);
    }];

    [self.view setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self.view  updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view  layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.scanningImageView setHidden:NO];
    }];
    
    
    
    //扫描线动画
    [self.scanningImageView.layer removeAllAnimations];
    
    CABasicAnimation *scanningAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    scanningAnimation.byValue = @(SCREEN_W - 130);
    
    scanningAnimation.duration = 2.0;
    
    scanningAnimation.repeatCount = MAXFLOAT;
    
    self.scanningImageView.layer.speed = 0.8;
    
    [self.scanningImageView.layer addAnimation:scanningAnimation forKey:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
