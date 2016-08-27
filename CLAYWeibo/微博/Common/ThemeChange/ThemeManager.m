//
//  ThemeManager.m
//  微博
//
//  Created by CLAY on 16/5/13.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager


//初始化方法, 完成最初主题,和选定后的主题保存
-(instancetype)init{
    if (self = [super init]) {
        NSString *theme = [[NSUserDefaults standardUserDefaults] objectForKey:kStandardTheme];
        if (theme) {
            _themeName = theme;
        }else{
            _themeName = @"Happy Toy";
        }

    }
    return self;
}


//设置单例 类方法,有声明
+ (ThemeManager *)shareThemeManager{
    static ThemeManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[[self class] alloc] init];  //类对象≠类(名) , self是类对象
    });
    return manager;
}


//监控主题的get方法, 因为主题的改变都需要通过设置此属性. 每次设置都将设置保存到本地.
- (void)setThemeName:(NSString *)themeName{
    if (![_themeName isEqualToString:themeName]) {
        _themeName = [themeName copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChanged object:nil];
        [[NSUserDefaults standardUserDefaults] setValue:_themeName forKey:kStandardTheme];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}




//得到素材文件的相对路径 , imageNamed: 相对路径(即工程内的路径).
- (NSString *)getThemePath{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme.plist" ofType:nil];
    _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
    return _themeConfig[_themeName];
}




//接收通知的控件类,通过调用这的方法(并传入需要的名字),得到最终准确路径,从而确定图片. 得声明给外界接口.
//此类的封装,一是保存当前主题/设置通知 , 二就是为了封装这个方法
- (UIImage *)getImage:(NSString *)name{
    if (name.length == 0) {
        return nil;
    }

    NSString *themePath = [self getThemePath];
    NSString *imagePath = [themePath stringByAppendingPathComponent:name];
    return [UIImage imageNamed:imagePath];

}


//得到素材文件夹中的 颜色文件"config.plist"的颜色 , 要声明
- (UIColor *)getColor:(NSString *)colorName{
    if (colorName.length == 0) {
        return nil;
    }


    NSString *themePath = [self getThemePath];
    NSString *path = [themePath stringByAppendingPathComponent:@"config.plist"];
    NSString *colorPath = [[NSBundle mainBundle] pathForResource:path ofType:nil];

    _themeColor = [NSDictionary dictionaryWithContentsOfFile:colorPath];
    NSDictionary *rgbDic = _themeColor[colorName];
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    CGFloat alpha = [rgbDic[@"alpha"] floatValue];
    if (rgbDic[@"alpha"] == nil) {
        alpha = 1;
    }

    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];

}





@end
