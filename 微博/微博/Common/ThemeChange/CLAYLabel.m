//
//  CLAYLabel.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYLabel.h"
#import "ThemeManager.h"

@implementation CLAYLabel

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kThemeChanged object:nil];

}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];

}

// 通知方法
- (void)themeChanged{
    [self getLabelColor];
}

//颜色名set方法 让外界一设置属性就改变其textColor
-(void)setColor:(NSString *)color{
    if (![_color isEqualToString:color]) {
        _color = [color copy];
        [self getLabelColor];
    }
}


-(void)getLabelColor{
    ThemeManager *manager = [ThemeManager shareThemeManager];
    UIColor *color = [manager getColor:_color];
    self.textColor = color;
}




@end
