//
//  FaceScrollView.h
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface FaceScrollView : UIView<UIScrollViewDelegate>{

    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    FaceView *_faceView;

}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate;

@end

