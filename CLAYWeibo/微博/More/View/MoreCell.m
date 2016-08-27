//
//  MoreCell.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "MoreCell.h"
#import "ThemeManager.h"


@implementation MoreCell

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChanged object:nil];
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self _createSubView];
//        [self themeChanged];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];
//
//
//    }
//    return self;
//}

//注册类单元格 ,调用方法不是普通视图的-initWithFrame:
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:kMoreCell]) {
        [self _createSubView];
        [self themeChanged];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChanged object:nil];


    }
    return self;

}



- (void)themeChanged{
    ThemeManager *manager = [ThemeManager shareThemeManager];
    self.backgroundColor = [manager getColor:@"More_Item_color"];

}

- (void)_createSubView{
//单元格默认高度好像是30 不会随着子视图改变. 自己有协议设置.
    _cellImageView = [[CLAYImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];

    _cellLabel = [[CLAYLabel alloc] initWithFrame:CGRectMake(_cellImageView.right+5, 11, 200, 20)];

    _themeDetailLabel = [[CLAYLabel alloc] initWithFrame:CGRectMake(self.right-125, 11, 95, 20)];

    _cellLabel.font = [UIFont boldSystemFontOfSize:16];
    _cellLabel.backgroundColor = [UIColor clearColor];
    _cellLabel.color = @"More_Item_Text_color";

    _themeDetailLabel.font = [UIFont boldSystemFontOfSize:15];
    _themeDetailLabel.backgroundColor = [UIColor clearColor];
    _themeDetailLabel.color = @"More_Item_Text_color";
    _themeDetailLabel.textAlignment = NSTextAlignmentRight;

    [self.contentView addSubview:_cellImageView];
    [self.contentView addSubview:_cellLabel];
    [self.contentView addSubview:_themeDetailLabel];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
