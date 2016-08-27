//
//  WeiboTabBarController.m
//  微博
//
//  Created by CLAY on 16/5/13.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "WeiboTabBarController.h"
#import "CLAYButton.h"
#import "BaseNavigationController.h"
#import "CLAYImageView.h"


@class CLAYButton;

@interface WeiboTabBarController (){
    CLAYImageView *_selectImage;

}

@end

@implementation WeiboTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViewControllers];
//    NSLog(@"%@",self.tabBar.subviews);
    [self _createTabBar];

    //气泡提示数目的数据刷新
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

//    NSLog(@"%@",self.tabBar.subviews);
}




#pragma mark - 自定义标签栏
- (void)_createViewControllers{
    NSArray *array = @[@"Home",@"Discover",@"Profile",@"More"];
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSString *name in array) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
        BaseNavigationController *nav = sb.instantiateInitialViewController;
        [controllers addObject:nav];
    }
    self.viewControllers = controllers;
}

- (void)_createTabBar{
    //移除系统tabBar上的 系统按钮(创建子控制器后自动生成)
    Class cls = NSClassFromString(@"UITabBarButton");
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
//    NSLog(@"%@",self.tabBar.subviews);

    //设置tabbar背景图片
    CLAYImageView *tabBarView = [[CLAYImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    tabBarView.imageName = @"mask_navbar";
    [self.tabBar addSubview:tabBarView];



    //创建选中图片
    CGFloat btnWidth = kScreenWidth/4;
    _selectImage = [[CLAYImageView alloc] initWithFrame:CGRectMake(0, 0, btnWidth, 49)];
    _selectImage.imageName = @"home_bottom_tab_arrow";
    [self.tabBar addSubview:_selectImage];

    //创建标签按钮
    NSArray *btnName = @[@"home_tab_icon_1",
                         @"home_tab_icon_3",
                         @"home_tab_icon_4",
                         @"home_tab_icon_5"];
    for (NSInteger i = 0; i<btnName.count; i++) {
        CLAYButton *btn = [[CLAYButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, 49)];
        btn.tag = i;
        btn.normalName = btnName[i];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btn];
    }


}

- (void)btnAction:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        _selectImage.center = btn.center;
    }];
    self.selectedIndex = btn.tag;
}


#pragma mark - 定时器请求未读消息
- (void)timerAction{

    AppDelegate *appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaweibo;

    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];

}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{

    CGFloat tabBarButtonWidth = kScreenWidth/5;

    // 必须加判断 才能保证属性的唯一 ,否则一直创建/各种不同的地址
    if (_badgeView == nil) {
        _badgeView = [[CLAYImageView alloc] initWithFrame:CGRectMake(tabBarButtonWidth-32, 0, 32, 32)];
        _badgeView.imageName =@"number_notify_9.png";
        [self.tabBar addSubview:_badgeView];

        _badgeLabel = [[CLAYLabel alloc] initWithFrame:_badgeView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.color = @"Timeline_Notice_color";
        [_badgeView addSubview:_badgeLabel];
    }


    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];

    if (count > 0 ) {

        _badgeView.hidden = NO;
        if (count >= 100) {
            count = 99;
        }

        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];

    }else{

        _badgeView.hidden = YES;

    }
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
