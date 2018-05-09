//
//  QRCodeScanViewController.h
//  AnXinClient
//
//  Created by GOKIT on 2018/2/26.
//  Copyright © 2018年 AnXin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef BOOL(^QRCodeScanCompletion)(NSString *result);


@interface QRCodeScanViewController : UIViewController

@property (nonatomic,copy) QRCodeScanCompletion qrCodeScanCompletion;

@end
