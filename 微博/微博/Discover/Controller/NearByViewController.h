//
//  NearByViewController.h
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>{

    CLLocationManager *_locationManager;
    
    MKMapView *_mapView;

}

@end
