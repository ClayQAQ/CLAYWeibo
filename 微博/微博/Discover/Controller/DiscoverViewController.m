//
//  DiscoverViewController.m
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"


@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //调用父类方法 设置导航两侧按钮
    [self setBothSidesNavItem];

    //设置两个CLAYLabel颜色
    [self _changeLabelColor];

}


- (void)_changeLabelColor{
    _weiboLabel.color = @"Timeline_Name_color";
    _peopleLabel.color = @"Timeline_Name_color";
}



- (IBAction)nearbyWeibo:(id)sender {
    NearByViewController *near = [[NearByViewController alloc] init];
    [self.navigationController pushViewController:near animated:YES];

}
- (IBAction)nearbyPeople:(id)sender {
    NearByViewController *near = [[NearByViewController alloc] init];
    [self.navigationController pushViewController:near animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
