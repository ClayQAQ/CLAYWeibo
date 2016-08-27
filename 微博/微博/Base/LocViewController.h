//
//  LocViewController.h
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"
#import  <CoreLocation/CoreLocation.h>
#import "PoiModel.h"



@interface LocViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
}
@property (nonatomic ,strong) NSArray *dataList;

@end
