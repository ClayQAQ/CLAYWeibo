//
//  ThemeManager.h
//  微博
//
//  Created by CLAY on 16/5/13.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>
//通知中心的name
#define kThemeChanged @"ThemeChanged"
//本地保存的key
#define kStandardTheme @"StandardTheme"

@interface ThemeManager : NSObject
//记录当前主题的名字  设置单例才能保证不管在哪里创建,保存的主题(属性)都一样.
@property (nonatomic, copy) NSString *themeName;
//保存解析"theme.plist"后的字典
@property (nonatomic, strong) NSDictionary *themeConfig;
//保存解析主题对应字体颜色的字典
@property (nonatomic, strong) NSDictionary *themeColor;


+ (ThemeManager *)shareThemeManager;

- (UIColor *)getColor:(NSString *)colorName;

- (UIImage *)getImage:(NSString *)name;

@end
