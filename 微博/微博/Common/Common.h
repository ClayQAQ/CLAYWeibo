//
//  Common.h
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+CLAYExtension.h"

#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表
#define send_update @"statuses/update.json"  //发微博(不带图片)
#define send_upload @"statuses/upload.json"  //发微博(带图片)
#define geo_to_address @"location/geo/geo_to_address.json" //查询坐标对应的位置
#define nearby_pois @"place/nearby/pois.json" // 附近商圈
#define nearby_timeline  @"place/nearby_timeline.json" //附近动态
#define user_show @"users/show.json" //用户信息


//微博字体
#define FontSize_Weibo(isDetail) isDetail?16:15
#define FontSize_ReWeibo(isDetail) isDetail?15:14



#define kAppKey         @"1390469839"
#define kAppSecret      @"3d2fd64383ef236bdf1d977173401b5b"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#endif /* Common_h */
