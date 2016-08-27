//
//  LocViewController.m
//  微博
//
//  Created by CLAY on 16/5/22.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "LocViewController.h"
#include "DataService.h"
#import "UIImageView+WebCache.h"

@interface LocViewController ()

@end

@implementation LocViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化子视图
    [self _createTableView];

    //定位
    _locationManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue]  >= 8.0) {
        // 请求允许定位
        [_locationManager requestWhenInUseAuthorization];
    }
    //设置请求的准确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];

}

#pragma mark - 创建表视图,Nav返回按钮
- (void)_createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //显示出BseViewController的背景色  cell也需要改为透明
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    

}


#pragma mark - 网络加载
- (void)loadNearByPoisWithlon:(NSString *)lon lat:(NSString *)lat
{
    //配置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];//经度
    [params setObject:lat forKey:@"lat"];
    [params setObject:@30 forKey:@"count"];

    //请求数据

    //获取附近商家
    [DataService requestUrl:nearby_pois httpMethod:@"GET" params:params block:^(id result) {
        NSArray *pois = result[@"pois"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            // 创建商圈模型对象
            PoiModel *poi = [[PoiModel alloc]initWithDataDic:dic];
            [dataList addObject:poi];

        }
        self.dataList = dataList;
        [_tableView reloadData];
    }];


}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [manager stopUpdatingLocation];

    //获取当前请求的位置
    CLLocation *location = [locations lastObject];

    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    //开始加载网络
    [self loadNearByPoisWithlon:lon lat:lat];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *locCellId = @"locCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locCellId];
        cell.backgroundColor = [UIColor clearColor];
    }
    //获取当前单元格对应的商圈对象
    PoiModel *poi = self.dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon]];

    cell.textLabel.text = poi.title;
    return cell;
}


- (void)backAction{

    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
