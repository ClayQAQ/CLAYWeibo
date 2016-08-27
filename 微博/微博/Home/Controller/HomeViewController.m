//
//  HomeViewController.m
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewLayoutFrame.h"
#import "MJRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CLAYLabel.h"
#import "CLAYImageView.h"
#import "WeiboTabBarController.h"

@interface HomeViewController ()<SinaWeiboRequestDelegate,SinaWeiboDelegate>



@end

@implementation HomeViewController{
    WeiboTableView *_tableView;
    NSMutableArray *_data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createTableView];
//    [self _weiboRequest];
    [self setBothSidesNavItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 保证SSO认证的运行,延迟调用[self _weiboRequest] 
//但是这个方法不同于viewDidLoad,他每次切回这个频道都会调用 , 所以每次都会请求数据! 所以数据会有显示延迟!  第一次加载会延迟较大,所以增加加载动画时间与之照应 !
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static BOOL i = NO;
    if (!i) {
        [self _weiboRequest];
        i = YES;
    }

}



//  viewWillAppear 也不能用SSO  会打断
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    static BOOL i = NO;
//    if (!i) {
//        [self _weiboRequest];
//        i = YES;
//    }
//}

#pragma mark - 创建表视图
- (void)_createTableView{

    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];

    //添加refresh控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadOldData)];
    
}


#pragma mark - 微博网络请求/上拉刷新,上拉加载更多
//get微博对象
- (SinaWeibo *)sinaWeibo{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    return app.sinaweibo;
}

//设置Home页的数据请求 (第一次进入时,加载10个)
- (void)_weiboRequest{
    SinaWeibo *weibo = [self sinaWeibo];
    NSDictionary *params = @{@"count":@"10"}; //传入参数时 必须传入可变的字典.
    if ([weibo isAuthValid]) {
           SinaWeiboRequest *request = [weibo requestWithURL:home_timeline params:[params mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = 1;

        //显示加载提示 并隐藏表视图(即隐藏表格线)
        [self showHUD:@"正在加载..."];
        _tableView.hidden = YES;
    }else{

        [weibo logIn];

        
    }
}

//下拉刷新数据,通过后面监听处理数据的协议 ,如果有新数据,就把新数据加到_data前面
- (void)_loadNewData{
    SinaWeibo *weibo = [self sinaWeibo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"count"];

    //加判断 ,开始加载成功后则肯定有了. 防止还没加载完第一次就下拉(网络卡或者没网络时).
    if (_data.count) { // 即data不为空时,如果真为空,则继续执行下面的请求点数据也不为过
        WeiboViewLayoutFrame *layout = [_data firstObject];
        NSString *since_id = layout.weiboModel.weiboId.stringValue;
        [params setObject:since_id forKey:@"since_id"];

        
    }

//如果网络一直卡, 其下载完成的协议方法也不会调用,菊花也不会停止转动.
    SinaWeiboRequest *request = [weibo requestWithURL:home_timeline
                                               params:params
                                           httpMethod:@"GET"
                                             delegate:self];

    request.tag = 2;


}


//下拉加载更老的数据
- (void)_loadOldData{
    SinaWeibo *weibo = [self sinaWeibo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"count"];

//与上同理
    if (_data.count) {
        WeiboViewLayoutFrame *layout = [_data lastObject];
        NSString *max_id = layout.weiboModel.weiboId.stringValue;
        [params setObject:max_id forKey:@"max_id"];

    }

    SinaWeiboRequest *request = [weibo requestWithURL:home_timeline
                                               params:params
                                           httpMethod:@"GET"
                                             delegate:self];

    request.tag = 3;

}




#pragma mark - 微博网络请求代理(服务器返回数据并处理数据)

//网络请求失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络接口请求失败：%@",error);

}



//网络请求成功
// result是sdk处理好的数据 (OC对象,字典或者数组).
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{

    NSArray *statuses = [result objectForKey:@"statuses"];

    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];

    for (NSDictionary *dataDic in statuses) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dataDic];

        WeiboViewLayoutFrame *layoutFrame = [[WeiboViewLayoutFrame alloc] init];

    //调用其set方法 ,也开始计算weiboModel对应的frame,并且存到当前layoutFrame中, 到下一步就存到了全局数组layoutFrameArray中.
        layoutFrame.weiboModel = weiboModel;

        [layoutFrameArray addObject:layoutFrame];


    }

    if (request.tag == 1) { ////说明当前request是第一次进入Home时请求


        _data = layoutFrameArray;
        //关闭加载提示
        _tableView.hidden = NO;
        [self completeHUD:@"加载完成"];
        [self hideHUD];

    }else if (request.tag ==2){ //说明当前request是加载新数据请求
        if (layoutFrameArray.count > 0) {
            //插入位置和插入长度
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];

            //增加prompt 长条提示
            [self showPrompt:layoutFrameArray.count];

            //关闭气泡提示
            // 或者是 self.tabBarController 也可以得到标签控制器对象
            WeiboTabBarController *tc = (WeiboTabBarController *)self.parentViewController.parentViewController;
            tc.badgeView.hidden = YES;

        }



    }else if (request.tag == 3){//说明当前request是加载旧数据请求
        // >1是因为微博API的 max_id参数是返回≤它的. (所以包括现在已有的最后一个)
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];

        }
    }



    _tableView.layoutFrameArray = _data;
    [_tableView reloadData];

    //数据填充 ,则结束refresh
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];


}


#pragma mark - prompt设置
- (void)showPrompt:(NSInteger)count{

//创建prompt. 因为导航栏不透明,则prompt是在导航栏下面藏着.
    CLAYImageView *promptImageView = [[CLAYImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
    promptImageView.imageName = @"timeline_notify.png";
    [self.view addSubview:promptImageView];

    CLAYLabel *promptLabel = [[CLAYLabel alloc] initWithFrame:promptImageView.bounds];
    promptLabel.color = @"Timeline_Notice_color";
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptImageView addSubview:promptLabel];

    //设置动画
    if (count > 10) {
        promptLabel.text = [NSString stringWithFormat:@"更新了%li+条微博",count];
    }else{
        promptLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];

    }
    [UIView animateWithDuration:0.4 animations:^{

        promptImageView.transform = CGAffineTransformMakeTranslation(0, 40+3);

    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.6 animations:^{
                //延时执行动画
                [UIView setAnimationDelay:1];
                promptImageView.transform = CGAffineTransformIdentity;
            }];
        }

    }];


    // 声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //注册系统声音
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    //播放
    AudioServicesPlaySystemSound(soundId);


    
    
    
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
