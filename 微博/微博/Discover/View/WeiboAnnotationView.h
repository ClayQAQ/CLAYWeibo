//
//  WeiboAnnotationView.h
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WeiboAnnotation.h"
#import "WeiboModel.h"

//自定义 AnnotationView
@interface WeiboAnnotationView : MKAnnotationView{
    UIImageView *_userHeadImageView;//头像图片
    UILabel *_textLabel;//微博内容
}



@end