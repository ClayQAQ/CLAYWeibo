//
//  UIView+ViewController.h
//  微博
//
//  Created by CLAY on 16/5/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewController)

//得到如果视图创建并且被加载到控制器中，则可以用此方法直接找到上层一级控制器  《响应者链》
- (UIViewController *)viewController;

@end
