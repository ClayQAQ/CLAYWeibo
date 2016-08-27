//
//  WeiboViewLayoutFrame.h
//  微博
//
//  Created by CLAY on 16/5/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"

@interface WeiboViewLayoutFrame : NSObject

@property (nonatomic, assign) CGRect textFrame;//微博内容的 frame
@property (nonatomic, assign) CGRect srTextFrame;//原微博内容的frame
@property (nonatomic, assign) CGRect bgImgFrame;//原微博背景图片 frame
@property (nonatomic, assign) CGRect imgFrame;//微博图片的frame
@property (nonatomic, assign) CGRect frame;//整个weiboView的frame
@property (nonatomic, strong) WeiboModel *weiboModel;//微博model

@property (nonatomic, assign) BOOL isDetail;
@end
