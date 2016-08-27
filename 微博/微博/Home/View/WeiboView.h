//
//  WeiboView.h
//  微博
//
//  Created by CLAY on 16/5/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CLAYImageView.h"
#import "WeiboViewLayoutFrame.h"
#import "ThemeManager.h"
#import "ScaleImageView.h"


@interface WeiboView : UIImageView<WXLabelDelegate>

@property (nonatomic,strong) WXLabel *textLabel;//微博文字
@property (nonatomic,strong) WXLabel *sourceLabel;//原微博文字
@property (nonatomic,strong) ScaleImageView *imgView;//微博图片
@property (nonatomic,strong) CLAYImageView *bgImgView;//转发气泡背景(在原微博+(图片)之下) ,它和原微博图片,和原微博文字都可能没有 . 都是有判断的.
@property (nonatomic,strong) WeiboViewLayoutFrame *layoutFrame;



@end
