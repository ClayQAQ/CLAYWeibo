//
//  AppDelegate.m
//  微博
//
//  Created by CLAY on 16/5/11.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboTabBarController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"

@class MyTabbarController;
@interface AppDelegate (){
    HomeViewController *_home;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {



    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];


    self.sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kRedirectURI andDelegate:self];


    //查看本地 查看登录的信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"CLAYWeiboAuthData"];

    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }


    //设置左中右控制器
    LeftViewController *leftVc = [[LeftViewController alloc] init];
    RightViewController *rightVc = [[RightViewController alloc] init];
    WeiboTabBarController *mainVc = [[WeiboTabBarController alloc] init];

    MMDrawerController *mmDraw = [[MMDrawerController alloc] initWithCenterViewController:mainVc leftDrawerViewController:leftVc rightDrawerViewController:rightVc];

    //设置右边view宽度
    [mmDraw setMaximumRightDrawerWidth:75];
    [mmDraw setMaximumLeftDrawerWidth:125];

    //设置手势区域
    [mmDraw setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDraw setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];


    //设置动画类型
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeParallax];

    //设置动画
    [mmDraw
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {

         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];



    self.window.rootViewController = mmDraw;


// 取得那个HomeViewController对象.
    BaseViewController *nav = [mainVc.viewControllers firstObject];
    _home = [nav.childViewControllers firstObject];







    return YES;
}



#pragma mark - SinaWeiboDelegate logIN logOut
-(void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{

    //保存登录信息
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];

    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"CLAYWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //在此logIn监听方法中,解决第一次登陆成功后无数据的问题.
    [_home _weiboRequest];
    
}

-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"登出");
    //移除本地信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLAYWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    //设置提示
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"已经登出";
    //延迟隐藏
    [_hud hide:YES afterDelay:1.5];

}


#pragma mark - SSO配置
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaweibo handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaweibo handleOpenURL:url];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.sinaweibo applicationDidBecomeActive];
}







@end
