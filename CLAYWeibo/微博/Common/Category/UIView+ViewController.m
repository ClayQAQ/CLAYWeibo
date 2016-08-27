//
//  UIView+ViewController.m
//  微博
//
//  Created by CLAY on 16/5/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)


-(UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    while (next) {  //如果next不为空
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }else{
            next = next.nextResponder;
        }
    }
    return nil;
}

@end
