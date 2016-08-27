//
//  MoreViewController.m
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeChangeController.h"
#import "MoreCell.h"
#import "ThemeManager.h"
#import "AppDelegate.h"



@interface MoreViewController (){

    UITableView *_tableView;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createTableView];
    [self setBothSidesNavItem];

}

//每次显示时都显示最新数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)_createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MoreCell class] forCellReuseIdentifier:kMoreCell];
    [self.view addSubview:_tableView];


}






#pragma mark - tableViewDelegate
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//每个组的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 2;
    }else{
        return 1;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreCell forIndexPath:indexPath];
    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
            cell.cellImageView.imageName = @"more_icon_theme.png";
            cell.cellLabel.text = @"主题选择";
            cell.themeDetailLabel.text = [ThemeManager shareThemeManager].themeName;
        }
        else if(indexPath.row == 1) {
            cell.cellImageView.imageName = @"more_icon_account.png";
            cell.cellLabel.text = @"账户管理";
        }
    }
    else if(indexPath.section == 1) {
        cell.cellLabel.text = @"意见反馈";
        cell.cellImageView.imageName = @"more_icon_feedback.png";
    }
    else if(indexPath.section == 2) {
        cell.cellLabel.text = @"登出当前账号";
        cell.cellLabel.textAlignment = NSTextAlignmentCenter;

        cell.cellLabel.center = cell.contentView.center;
    }

    //设置箭头
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;

}


//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//取消点击滞留效果.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (indexPath.section == 0 && indexPath.row == 0) {
        ThemeChangeController *vc = [[ThemeChangeController alloc] init];

        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否登出账号?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self logOut];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - 登出账号 / 同时会在AppDelegate调用登出协议方法sinaweiboDidLogOut:
- (void)logOut{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.sinaweibo logOut];
}



@end

