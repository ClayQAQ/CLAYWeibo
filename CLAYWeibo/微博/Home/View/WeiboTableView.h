//
//  WeiboTableView.h
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeiboTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

//布局对象
@property (nonatomic,strong) NSArray *layoutFrameArray;


@end
