//
//  CLAYButton.m
//  微博
//
//  Created by CLAY on 16/5/13.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYButton.h"
#import "ThemeManager.h"

@implementation CLAYButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];

    }
    return self;
}

- (void)themeChanged{
    [self getImage];
}


- (void)setNormalName:(NSString *)normalName{
    if (![_normalName isEqualToString:normalName]) {
        _normalName = [normalName copy];

        [self getImage];
    }
}



// btn设置背景图片的方法,被上面两个方法调用
- (void)getImage{
    ThemeManager *manager = [ThemeManager shareThemeManager];
    UIImage *image = [manager getImage:_normalName];
    [self setImage:image forState:UIControlStateNormal];
    

}


//通知的观察者需要手动移除
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChanged object:nil];

}



@end
