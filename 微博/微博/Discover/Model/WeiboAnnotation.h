//
//  WeiboAnnotation.h
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"


@interface WeiboAnnotation : NSObject<MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

//坐标从 weiboModel中获取
@property (nonatomic,strong) WeiboModel *weiboModel;






@end
