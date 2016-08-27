//
//  WeiboCell.h
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "WeiboView.h"
#import "CLAYLabel.h"

@interface WeiboCell : UITableViewCell

@property (nonatomic,strong) WeiboView *weiboView;
@property (nonatomic,strong) WeiboViewLayoutFrame *layoutFrame;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet CLAYLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *repostCountLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *sourceLabel;

@end
