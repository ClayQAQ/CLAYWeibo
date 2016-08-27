//
//  WeiboView.m
//  微博
//
//  Created by CLAY on 16/5/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//


#import "WeiboView.h"
#import "UIImageView+WebCache.h"




@implementation WeiboView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubViews];

        //监听主题切换
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(themeChanged)
                                                     name:kThemeChanged object:nil];
        //self继承UIImageView
        self.userInteractionEnabled = YES;
    }

    return  self;
}
- (void)_createSubViews{


    //1 微博内容
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _textLabel.linespace = 5;

    _textLabel.wxLabelDelegate = self;
    [self addSubview:_textLabel];


    //2 原微博内容
    _sourceLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.linespace = 5;

    _sourceLabel.wxLabelDelegate = self;
    [self addSubview:_sourceLabel];


    //3 图片
    _imgView = [[ScaleImageView alloc] initWithFrame:CGRectZero];
#warning 图片等比例拉伸
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgView];

    //4 原微博背景图片

    _bgImgView = [[CLAYImageView alloc] initWithFrame:CGRectZero];
    // _bgImgView.backgroundColor = [UIColor redColor];

    //拉伸点设置
    _bgImgView.leftCapWidth = 25;
    _bgImgView.topCapWidth = 15;

    _bgImgView.imageName = @"timeline_rt_border_9";



    //插入到self作为父视图的 子视图最底层.
    [self insertSubview:_bgImgView atIndex:0];



}


- (void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame{
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }

}


//- (void)btnAction{
//    NSLog(@"btn被点击");
//}

- (void)layoutSubviews{

    [super layoutSubviews];

    _textLabel.font =   [UIFont systemFontOfSize: FontSize_Weibo(_layoutFrame.isDetail)] ;
    _sourceLabel.font =  [UIFont systemFontOfSize: FontSize_ReWeibo(_layoutFrame.isDetail)] ;


    WeiboModel *weiboModel = self.layoutFrame.weiboModel;

#warning 背景图片的fullImageUrlString 接收大图/中图urlString数据  ________________
    self.imgView.fullImageUrlString = weiboModel.originalImage;
    self.imgView.midImageString = weiboModel.bmiddlelImage;

    //1 设置微博文字
    _textLabel.frame = self.layoutFrame.textFrame;
    _textLabel.text = weiboModel.text;

    //2  微博是否是转发的

    if (weiboModel.reWeiboModel != nil) {
        self.bgImgView.hidden = NO;
        self.sourceLabel.hidden = NO;
        //原微博背景图片frame
        self.bgImgView.frame = self.layoutFrame.bgImgFrame;

        //原微博内容及frame
        self.sourceLabel.text = weiboModel.reWeiboModel.text;
        self.sourceLabel.frame = self.layoutFrame.srTextFrame;
        



        NSString *imgUrl = weiboModel.reWeiboModel.thumbnailImage;
        if (imgUrl != nil) {
            self.imgView.hidden = NO;
            self.imgView.frame = self.layoutFrame.imgFrame;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];

        }else{

            self.imgView.hidden = YES;
        }

    }else{
        self.bgImgView.hidden = YES;
        self.sourceLabel.hidden = YES;
        NSString *imgUrl = weiboModel.thumbnailImage;
        //是否有图片
        if (imgUrl == nil) {
            self.imgView.hidden = YES;
        }else{
            self.imgView.hidden = NO;
            self.imgView.frame = self.layoutFrame.imgFrame;

            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];

        }

    }
    
}







#pragma  mark - WXLabel delegate
//链接被点击之后调用
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{

    NSLog(@"%@",context);
}

//返回处理链接的表达式
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";

    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    //return  [UIColor redColor];

    return [[ThemeManager shareThemeManager] getColor:@"Link_color"];


}
//链接点击高亮颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor redColor];
}








#pragma mark - 主题通知
//这里用的是WXLabel , 所以监听主题得自己监听 ,然后改变label字体颜色.

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChanged object:nil];
}



- (void)themeChanged{
    _textLabel.textColor = [[ThemeManager shareThemeManager] getColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManager shareThemeManager] getColor:@"Timeline_Content_color"];
}




@end
