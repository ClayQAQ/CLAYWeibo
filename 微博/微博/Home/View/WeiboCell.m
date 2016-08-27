//
//  WeiboCell.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"

@implementation WeiboCell

- (void)awakeFromNib {

    self.weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    //self.weiboView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.weiboView];

    //背景颜色去掉
    self.backgroundColor = [UIColor clearColor];

    //去掉单元格选中特效  (还是保留点及特效.取消选中特效 -->这个在tableView的点击协议中设置 des)
//    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //设置主题Label的颜色
    self.userNameLabel.color = @"Timeline_Name_color";
    self.commentCountLabel.color =@"Timeline_Name_color";
    self.repostCountLabel.color =@"Timeline_Name_color";
    self.createTimeLabel.color =@"Timeline_Time_color";
    self.sourceLabel.color =@"Timeline_Time_color";


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame{

    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }

}


- (void)layoutSubviews{
    [super layoutSubviews];



    WeiboModel *model = self.layoutFrame.weiboModel;

    //头像
    NSString *urlStr = model.userModel.avatar_large;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];

    //用户昵称
    self.userNameLabel.text = model.userModel.screen_name;

    //转发数
    self.repostCountLabel.text = [NSString stringWithFormat:@"转发:%@",model.repostsCount];

    //评论数

    self.commentCountLabel.text =[NSString stringWithFormat:@"评论:%@",model.commentsCount];

    //发布时间
    //封装工具类，为后面代码提供便利
    self.createTimeLabel.text = [Utils weiboDateString:model.createDate];

    //weiboView设置
    self.weiboView.layoutFrame = self.layoutFrame;
    self.weiboView.frame = self.layoutFrame.frame;

    //来源设置
    self.sourceLabel.text = model.source;

}

@end
