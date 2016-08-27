//
//  MoreCell.h
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLAYLabel.h"
#import "CLAYImageView.h"
#define kMoreCell @"MoreCell"


@interface MoreCell : UITableViewCell

//外界要传数据给他们 ,得有这些属性接口
@property (nonatomic, strong) CLAYImageView *cellImageView;
@property (nonatomic, strong) CLAYLabel *cellLabel;
@property (nonatomic, strong) CLAYLabel *themeDetailLabel;



@end
