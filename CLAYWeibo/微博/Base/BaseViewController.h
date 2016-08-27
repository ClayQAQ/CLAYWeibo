//
//  BaseViewController.h
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ThemeManager.h"
#import "AFHTTPRequestOperation.h"

@interface BaseViewController : UIViewController{
    MBProgressHUD *_hud;
}

//设置左右MMDraw按钮
- (void)setBothSidesNavItem;

//显示hud提示 (封装开源类)
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
//完成的提示
- (void)completeHUD:(NSString *)title;

@end
