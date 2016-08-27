//
//  WeiboViewLayoutFrame.m
//  微博
//
//  Created by CLAY on 16/5/16.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "WeiboViewLayoutFrame.h"
#import "WXLabel.h"

@implementation WeiboViewLayoutFrame

- (void)setWeiboModel:(WeiboModel *)weiboModel{

    if (_weiboModel != weiboModel) {

        _weiboModel = weiboModel;
        //重新计算各frame ,此方法中会填充frame属性
        [self _layoutFrame];

    }


}

- (void)_layoutFrame{

    //根据 weiboModel计算
    CGFloat weiboFontSize = FontSize_Weibo(self.isDetail);
    CGFloat reWeiboFontSize = FontSize_ReWeibo(self.isDetail);


    //1.微博视图的frame
    if (self.isDetail) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }else{
        self.frame = CGRectMake(55, 40, kScreenWidth-65, 0);

    }

    //2.微博内容的frame
    //1>计算微博内容的宽度
    CGFloat textWidth = CGRectGetWidth(self.frame)-20;

    //2>计算微博内容的高度
    NSString *text = self.weiboModel.text;
    CGFloat textHeight = [WXLabel getTextHeight:weiboFontSize width:textWidth text:text linespace:5.0];

    self.textFrame = CGRectMake(10, 0, textWidth, textHeight);

    //3.原微博的内容frame
    if (self.weiboModel.reWeiboModel != nil) {
        NSString *reText = self.weiboModel.reWeiboModel.text;

        //宽度
        CGFloat reTextWidth = textWidth-20;
        //高度

        CGFloat textHeight = [WXLabel getTextHeight:reWeiboFontSize width:reTextWidth text:reText linespace:5.0];

        //Y坐标
        CGFloat Y = CGRectGetMaxY(self.textFrame)+10;
        self.srTextFrame = CGRectMake(20, Y, reTextWidth, textHeight);

        //4.原微博的图片
        NSString *thumbnailImage = self.weiboModel.reWeiboModel.thumbnailImage;
        if (thumbnailImage != nil) {

            CGFloat Y = CGRectGetMaxY(self.srTextFrame)+10;
            CGFloat X = CGRectGetMinX(self.srTextFrame);

            // 根据是否是详情界面来 设置微博图片frame
            if (self.isDetail) {
                self.imgFrame = CGRectMake(X, Y, CGRectGetWidth(self.frame)-20, 160);
            } else {
                self.imgFrame = CGRectMake(X, Y, 80, 80);
            }
        }

        //4.原微博的背景
        CGFloat bgX = CGRectGetMinX(self.textFrame);
        CGFloat bgY = CGRectGetMaxY(self.textFrame);
        CGFloat bgWidth = CGRectGetWidth(self.textFrame);
        CGFloat bgHeight = CGRectGetMaxY(self.srTextFrame);
        if (thumbnailImage != nil) {
            bgHeight = CGRectGetMaxY(self.imgFrame);
        }
        bgHeight -= CGRectGetMaxY(self.textFrame);
        bgHeight += 10;

        self.bgImgFrame = CGRectMake(bgX, bgY, bgWidth, bgHeight);

    } else {
        //微博图片
        NSString *thumbnailImage = self.weiboModel.thumbnailImage;
        if (thumbnailImage != nil) {

            CGFloat imgX = CGRectGetMinX(self.textFrame);
            CGFloat imgY = CGRectGetMaxY(self.textFrame)+10;
            //当没有转发时, 微博图片frame设置
            if (self.isDetail) {
                self.imgFrame = CGRectMake(imgX , imgY, CGRectGetWidth(self.frame)-40, 160);
            } else {
                self.imgFrame = CGRectMake(imgX , imgY, 80, 80);
            }
            //   self.imgFrame = CGRectMake(imgX, imgY, 80, 80);
        }
    }

    //计算微博视图的高度：微博视图最底部子视图的Y坐标
    CGRect f = self.frame;
    if (self.weiboModel.reWeiboModel != nil) {
        f.size.height = CGRectGetMaxY(_bgImgFrame);
    }
    else if(self.weiboModel.thumbnailImage != nil) {
        f.size.height = CGRectGetMaxY(_imgFrame);
    }
    else {
        f.size.height = CGRectGetMaxY(_textFrame);
    }
    self.frame = f;




    
}



@end
