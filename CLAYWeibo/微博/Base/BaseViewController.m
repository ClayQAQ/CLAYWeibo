//
//  BaseViewController.m
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 这里设置视图控制器全透明会导致 push pop 不自然.
//    self.view.backgroundColor = [UIColor clearColor];

    //开始调用一次
    [self _setMyBackgroundColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置通知观察
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_setMyBackgroundColor) name:kThemeChanged object:nil];

    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_setMyBackgroundColor) name:kThemeChanged object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChanged object:nil];
}



#pragma mark - 统一设置self.view.backgroundColor ,避免透明
- (void)_setMyBackgroundColor{
    //设置导航控制器view的背景颜色
    ThemeManager *manager = [ThemeManager shareThemeManager];
    UIImage *bgImage = [manager getImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}





#pragma mark - 首次加载/加载提示方法封装 .子类调用
//显示hud提示
- (void)showHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    }

    [_hud show:YES];

    _hud.labelText = title;
    //_hud.detailsLabelText  //子标题

    //灰色的背景盖住其他视图
    _hud.dimBackground = YES;
}

- (void)hideHUD {

    //延迟隐藏
    //[_hud hide:YES afterDelay:(NSTimeInterval)]

    [_hud hide:YES];
}

//完成的提示
- (void)completeHUD:(NSString *)title {

    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;

    //延迟隐藏
    [_hud hide:YES afterDelay:2];
}





#pragma mark - base类设置MMDrawerController功能的按钮 的方法

- (void)leftAction{
    MMDrawerController *mmDraw = self.mm_drawerController;

    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}
- (void)rightAction{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];

}


//导航栏 左右两边按钮设置
- (void)setBothSidesNavItem{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发微博" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];

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
