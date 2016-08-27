//
//  CLAYImageView.m
//  微博
//
//  Created by CLAY on 16/5/13.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYImageView.h"
#import "ThemeManager.h"

@implementation CLAYImageView
// 对于这个工程的imageView, 下面两个初始化方法都可能会用到,所以都添加通知监听
- (void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];

    }
    return self;
}



// 通知发送时,调用监听方法
- (void)themeChanged{
    [self getImage];
}

//设置属性set方法
-(void)setImageName:(NSString *)imageName{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self getImage];
    }
}


//给imageView设置好图片
- (void)getImage{
    ThemeManager *manager = [ThemeManager shareThemeManager];
    UIImage *img = [manager getImage:_imageName];
    //拉伸点设置
    img = [img stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];
    self.image = img;
}




//通知观察者移除
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChanged object:nil];
}
@end
