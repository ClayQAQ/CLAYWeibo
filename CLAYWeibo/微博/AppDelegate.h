//
//  AppDelegate.h
//  微博
//
//  Created by CLAY on 16/5/11.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SinaWeibo *sinaweibo;

@end

