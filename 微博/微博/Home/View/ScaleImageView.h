//
//  ScaleImageView.h
//  微博
//
//  Created by CLAY on 16/5/18.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ScaleImageView;

@protocol ScaleImageView <NSObject>
@optional
//图片将要放大
- (void)imageWillZoomIn:(ScaleImageView *)imageView;
//图片将要缩小
- (void)imageWillZoomOut:(ScaleImageView *)imageView;
//图片已经放大
//图片已经缩小

@end



@interface ScaleImageView : UIImageView<NSURLSessionDataDelegate>{

    UIScrollView *_scrollView;
    UIImageView *_fullImageView;

}

@property(nonatomic,weak)id<ScaleImageView> delegate;

@property(nonatomic,copy)NSString *fullImageUrlString;
@property(nonatomic,copy)NSString *midImageString;

//warning GIF图片处理
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,assign)BOOL isGif;
@end
