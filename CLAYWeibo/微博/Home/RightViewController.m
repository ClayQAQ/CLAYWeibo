//
//  RightViewController.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "RightViewController.h"
#import "CLAYButton.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"
#import "LocViewController.h"

@interface RightViewController (){
    SendViewController *_sc;
}

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 创建侧栏按钮
- (void)_createBtn{
    // btn图片名字
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    NSInteger i = 0;
    for (NSString* name in imageNames) {
        CLAYButton *btn = [[CLAYButton alloc] initWithFrame:CGRectMake(18, 64+i*65, 44, 44)];
        btn.normalName = name;
        btn.tag = i;
        i++;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}


- (void)btnAction:(CLAYButton *)btn{
    if (btn.tag == 0) {
        _sc = [[SendViewController alloc] init];
        _sc.title = @"发送微博";

        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:_sc];

        CLAYButton *btn = [[CLAYButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        btn.normalName = @"button_icon_close";
        [btn addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];


        _sc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [self presentViewController:nav animated:YES completion:nil];

    }else if (btn.tag == 4){
// 因为self是没有nav的
        LocViewController *loc = [[LocViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loc];
        loc.title = @"附近的地点";
        [self presentViewController:nav animated:YES completion:nil];
    }
}


- (void)leftBarButtonItemAction{

    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw closeDrawerAnimated:YES completion:nil];
    // 回到home主页 并且关闭mmDraw
    [_sc dismissViewControllerAnimated:YES completion:nil];

    
}




@end
