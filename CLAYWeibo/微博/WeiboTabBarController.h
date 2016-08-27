//
//  WeiboTabBarController.h
//  微博
//
//  Created by CLAY on 16/5/13.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "CLAYImageView.h"
#import "CLAYLabel.h"

@interface WeiboTabBarController : UITabBarController <SinaWeiboRequestDelegate>{

    CLAYLabel *_badgeLabel;  //气泡数字
}

//为了能在HomeViewController获得它 ,实时刷新后隐藏. 等待数据定时器更新太慢了.
@property (nonatomic, strong)CLAYImageView *badgeView;


@end
