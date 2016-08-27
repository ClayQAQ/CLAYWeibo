//
//  WeiboTableView.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "DetailViewController.h"
#import "UIView+ViewController.h"

#define kWeiboCell @"WeiboCell"

@implementation WeiboTableView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _createView];
    }

    return self;

}

- (void)awakeFromNib{
    // self.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self _createView];
}


- (void)_createView{

    self.delegate = self;
    self.dataSource = self;

    self.backgroundColor = [UIColor clearColor];

    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:kWeiboCell];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  self.layoutFrameArray.count;
}



- (NSInteger)numberOfSections{

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [self dequeueReusableCellWithIdentifier:kWeiboCell forIndexPath:indexPath];

    //设置数据
    cell.layoutFrame = self.layoutFrameArray[indexPath.row];


    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{



    //得到 weiboView的高度
    WeiboViewLayoutFrame *weiboLayoutFrame = self.layoutFrameArray[indexPath.row];

    CGRect frame = weiboLayoutFrame.frame;
    CGFloat height = frame.size.height;

    return height+85;
}



//单元格点击协议
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中特效 , 仍保留点击特效
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //微博详情控制器
    DetailViewController *vc = [[DetailViewController alloc] init];


    //把weiboModel传给微博详情控制器
    WeiboViewLayoutFrame *layoutFrame = self.layoutFrameArray[indexPath.row];
    WeiboModel *model = layoutFrame.weiboModel;
    vc.weiboModel = model;

    //通过事件响应者链获得了此表视图的控制器  然后才能得到导航控制器进行push
    [self.viewController.navigationController pushViewController:vc
                                                        animated:YES];
//    NSLog(@"%@",self.nextResponder);
}





@end
