//
//  WeiboAnnotation.m
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "WeiboAnnotation.h"
#import <MapKit/MapKit.h>

@implementation WeiboAnnotation


- (void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    NSDictionary *geo = weiboModel.geo;


    NSArray *coordinates = [geo objectForKey:@"coordinates"];
    if (coordinates.count >= 2) {

        NSString *longitude = coordinates[0];
        NSString *latitude = coordinates[1];

        _coordinate = CLLocationCoordinate2DMake([longitude floatValue], [latitude floatValue]);
    }



}

@end
