//
//  DetailViewController.h
//  微博
//
//  Created by CLAY on 16/5/18.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"
#import "WeiboModel.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"

@interface DetailViewController : BaseViewController<SinaWeiboRequestDelegate>{

    CommentTableView *_tableView;
}

//评论的微博Model
@property(nonatomic,strong)WeiboModel *weiboModel;

//评论列表数据
@property(nonatomic,strong)NSMutableArray *data;


@end
