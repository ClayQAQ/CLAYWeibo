//
//  BaseNavigationController.m
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self navConfig];

#warning 让nav的背景色透明
    self.view.backgroundColor = [UIColor clearColor];

}





#pragma mark - Base导航控制器 接收主题改变通知,并作出相应方法
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChanged object:nil];
}

//这个程序的导航控制器的创建, 都是在storyboard中,故其会调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];

    }
    return self;
}

- (void)themeChanged{
    [self navConfig];
}


// Base导航控制器的配置方法
- (void)navConfig{
//    //设置导航控制器view的背景颜色
    ThemeManager *manager = [ThemeManager shareThemeManager];
//    UIImage *bgImage = [manager getImage:@"bg_home.jpg"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];

    //设置导航栏背景图片
    UIImage *navImage = [manager getImage:@"mask_titlebar64"];
    [self.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
#warning 导航栏透明度设置为不透明,以增加用户体验
    self.navigationBar.translucent = NO;

    //设置导航栏返回按钮的颜色
    UIColor *color = [manager getColor:@"Mask_Title_color"];
    //设置系统title和系统btn的颜色
    self.navigationBar.tintColor = color;

    //设置导航栏title字的颜色
    NSDictionary *dic = @{NSForegroundColorAttributeName:color};
    self.navigationBar.titleTextAttributes = dic;

    
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
