//
//  LeftViewController.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "LeftViewController.h"
#import "CLAYLabel.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadData];
    [self _createTableVeiw];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置数据
- (void)_loadData
{
    _sectionTitles = @[@"界面切换效果",@"图片浏览模式"];


    // 数组套数组
    _rowTitles = @[@[@"无",
                     @"偏移",
                     @"偏移&缩放",
                     @"旋转",
                     @"视差"],
                   @[@"小图",
                     @"大图"]];
}


#pragma mark - 创建表视图
- (void)_createTableVeiw{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:_tableView];


}



#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_rowTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不复用也可以,因为这里复用池不会有东西的
    static NSString *identifier = @"leftCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }


    cell.textLabel.text = _rowTitles[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


    CLAYLabel *sectionLabel = [[CLAYLabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    sectionLabel.color = @"More_Item_Text_color"; //label字体颜色
    sectionLabel.backgroundColor = [UIColor clearColor]; //label背景颜色
    sectionLabel.font = [UIFont boldSystemFontOfSize:18]; //系统粗体 18
    sectionLabel.text = [NSString stringWithFormat:@"  %@", _sectionTitles[section]];
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}




@end
