// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "UIViewController+MMDrawerController.h"

@implementation UIViewController (MMDrawerController)


#warning ~~~~~~~~~~~ 修改UIViewController+MMDrawerController 类目源码~


-(MMDrawerController *)mm_drawerController{
    // 不断向上找,直到找到MMDrawerController

    //因为这个是UIViewController的类目, 父类可以指向子类. 这个self可以是项目中的VC
    UIViewController *parentVC = self.parentViewController;

    while (parentVC) {
        if ([parentVC isKindOfClass:[MMDrawerController class]]) {
            return (MMDrawerController *)parentVC;  // return则结束方法,跳出循环
        }else{
            //这个不是则继续向上找,执行这个while循环
            parentVC = parentVC.parentViewController;
        }

    }
    // 直到parentVC为空 循环也会结束,然后返回nil
    return nil;


//    if([self.parentViewController isKindOfClass:[MMDrawerController class]]){
//        return (MMDrawerController*)self.parentViewController;
//    }
//    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
//            [self.parentViewController.parentViewController isKindOfClass:[MMDrawerController class]]){
//        return (MMDrawerController*)[self.parentViewController parentViewController];
//    }
//    else{
//        return nil;
//    }
}

-(CGRect)mm_visibleDrawerFrame{
    if([self isEqual:self.mm_drawerController.leftDrawerViewController] ||
       [self.navigationController isEqual:self.mm_drawerController.leftDrawerViewController]){
        CGRect rect = self.mm_drawerController.view.bounds;
        rect.size.width = self.mm_drawerController.maximumLeftDrawerWidth;
        return rect;
        
    }
    else if([self isEqual:self.mm_drawerController.rightDrawerViewController] ||
             [self.navigationController isEqual:self.mm_drawerController.rightDrawerViewController]){
        CGRect rect = self.mm_drawerController.view.bounds;
        rect.size.width = self.mm_drawerController.maximumRightDrawerWidth;
        rect.origin.x = CGRectGetWidth(self.mm_drawerController.view.bounds)-rect.size.width;
        return rect;
    }
    else {
        return CGRectNull;
    }
}

@end
