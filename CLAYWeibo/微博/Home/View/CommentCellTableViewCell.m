//
//  CommentCellTableViewCell.m
//  微博
//
//  Created by CLAY on 16/5/18.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CommentCellTableViewCell.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation CommentCellTableViewCell

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        _commentTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
//        _commentTextLabel.font = [UIFont systemFontOfSize:14.0f];
//        _commentTextLabel.linespace = 5;
//        _commentTextLabel.wxLabelDelegate = self;
//        [self.contentView addSubview:_commentTextLabel];
//
//        self.backgroundColor = [UIColor clearColor];
//
//    }
//    return self;
//}


- (void)awakeFromNib {
    _commentTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _commentTextLabel.font = [UIFont systemFontOfSize:14.0f];
    _commentTextLabel.linespace = 5;
    _commentTextLabel.wxLabelDelegate = self;
    [self.contentView addSubview:_commentTextLabel];

    self.backgroundColor = [UIColor clearColor];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //头像
    NSString *urlstring = _commentModel.user.profile_image_url;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlstring]];
    //昵称

    _nameLabel.text = _commentModel.user.screen_name;

    //评论内容
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:(kScreenWidth-70)
                                       text:_commentModel.text
                                  linespace:5];




    _commentTextLabel.frame = CGRectMake(_imgView.right+10, _nameLabel.bottom+5, kScreenWidth-70, height);

    _commentTextLabel.text = _commentModel.text;


}


//返回一个正则表达式，通过此正则表达式查找出需要添加超链接的文本
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex1 = @"@\\w+"; //@"@[_$]";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#^#+#";  //\w 匹配字母或数字或下划线或汉字

    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];

    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {

    UIColor *linkColor = [[ThemeManager shareThemeManager] getColor:@"Link_color"];
    return linkColor;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}


//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel {
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:kScreenWidth-70
                                       text:commentModel.text
                                  linespace:5];

    return height+40;
}



@end
