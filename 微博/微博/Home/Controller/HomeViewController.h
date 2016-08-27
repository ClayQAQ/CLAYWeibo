//
//  HomeViewController.h
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController 

//给主标签控制器接口, 在loginDelegate中实现此方法. 避免第一次登陆后无数据问题.
- (void)_weiboRequest;

@end
