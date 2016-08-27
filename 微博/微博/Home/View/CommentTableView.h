//
//  CommentTableView.h
//  微博
//
//  Created by CLAY on 16/5/18.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "UserView.h"
#import "CommentModel.h"
#import "CommentCellTableViewCell.h"


@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    //用户视图
    UserView *_userView;
    //微博视图
    WeiboView *_weiboView;
    //头视图
    UIView *_tableHeaderView;
}
@property(nonatomic,strong)NSArray *commentDataArray;//评论列表
@property(nonatomic,strong)WeiboModel *weiboModel;//微博model
@property(nonatomic,strong)NSDictionary *commentDic;//评论字典

@end
