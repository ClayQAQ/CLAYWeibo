//
//  SendViewController.h
//  微博
//
//  Created by CLAY on 16/5/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FaceScrollView.h"


@interface SendViewController : BaseViewController<CLLocationManagerDelegate,FaceViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    //文本编辑栏
    UITextView *_textView;
    //工具栏
    UIView *_editorBar;
    //GPS manager
    CLLocationManager *_locationManager;
    //现在位置 (text显示反编码后的)
    UILabel *_locationLabel;
    //状态栏提示
    UIWindow *_tipWindow;
    //表情面板
    FaceScrollView *_faceViewPanel;
    //选择的图片 (从album中)
    UIImage *_selectImage;


}

@end
