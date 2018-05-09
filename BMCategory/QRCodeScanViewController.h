//
//  QRCodeScanViewController.h
//  AnXinClient
//
//  Created by GOKIT on 2018/2/26.
//  Copyright © 2018年 AnXin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 二维码扫描回调函数

 @param result result 二维码扫描结果
 @return return value 二维码扫描完成是否关闭当前界面
 */
typedef BOOL(^QRCodeScanCompletion)(NSString *result);


@interface QRCodeScanViewController : UIViewController

- (instancetype)initWithResult:(QRCodeScanCompletion)qrCodeScanCompletion;

@end
