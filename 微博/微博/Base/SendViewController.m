//
//  SendViewController.m
//  微博
//
//  Created by CLAY on 16/5/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeManager.h"
#import "CLAYButton.h"
#import "DataService.h"
#import "RightViewController.h"
#import "UIProgressView+AFNetworking.h"


@interface SendViewController ()

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createEditorViews];
    [self _createSendBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化与接收键盘Frame改变通知
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return  self;


}

#pragma mark - 创建导航栏发送按钮 (返回按钮在上个控制器设置)
//button_icon_ok.png
- (void)_createSendBtn{
    CLAYButton *btn = [[CLAYButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    btn.normalName = @"button_icon_ok.png";
    [btn addTarget:self action:@selector(sendWeibo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

}

- (void)sendWeibo{
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }
    else if(text.length > 140) {
        error = @"微博内容大于140字符";
    }
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:error preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }


    //发送
    AFHTTPRequestOperation *operation =  [DataService sendWeibo:text image:_selectImage block:^(id result) {
        NSLog(@"发送成功");
        //状态栏显示
        [self showStatusTip:@"发送成功" show:NO operation:nil];

    }];

    [self showStatusTip:@"正在发送..." show:YES operation:operation];
    [self closeAction];
}

- (void)closeAction{
// 控制器的nextResponder只能得到UIViewControllerWrapperView
//    RightViewController *right = (RightViewController *)self.nextResponder;
//    [self dismissViewControllerAnimated:YES completion:^{
//        MMDrawerController *mmDraw = right.mm_drawerController;
//        [mmDraw closeDrawerAnimated:YES completion:nil];
//    }];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.rootViewController isKindOfClass:[MMDrawerController class]]) {
        MMDrawerController *mmDraw = (MMDrawerController *)window.rootViewController;
        [mmDraw closeDrawerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

#pragma mark - 状态栏提示

- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation{


    if (_tipWindow == nil) {
        //创建window
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];

        //创建Label
        UILabel *tpLabel = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tpLabel.backgroundColor = [UIColor clearColor];
        tpLabel.textAlignment = NSTextAlignmentCenter;
        tpLabel.font = [UIFont systemFontOfSize:13.0f];
        tpLabel.textColor = [UIColor whiteColor];
        tpLabel.tag = 100;
        [_tipWindow addSubview:tpLabel];


        //进度条
        UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progress.frame = CGRectMake(0, 20-3, kScreenWidth, 5);
        progress.tag = 101;
        progress.progress = 0.0;
        [_tipWindow addSubview:progress];


    }

    UILabel *tpLabel = (UILabel *)[_tipWindow viewWithTag:100];
    tpLabel.text = title;


    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];

    if (show) {
        _tipWindow.hidden = NO;
        if (operation != nil) {
            progressView.hidden = NO;
            //AF 对 UIProgressView的扩展
            [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        }else{
            progressView.hidden = YES;
        }


    }else{

        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
}


- (void)removeTipWindow{

    _tipWindow.hidden = YES;
    _tipWindow = nil;
}




#pragma mark - 创建工具栏
- (void)_createEditorViews{

    //文本输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;

    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_textView];

    //编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];

    //创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        CLAYButton *button = [[CLAYButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.normalName = imgName;
        [_editorBar addSubview:button];
    }

    //显示位置信息
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _locationLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    _locationLabel.textColor = [UIColor blackColor];
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.hidden = YES;
    [_editorBar addSubview:_locationLabel];



}

- (void)buttonAction:(UIButton*)button{
    NSLog(@"%li",button.tag);

    if (button.tag == 3) {
        [self _location];
    }

    if (button.tag == 0) {
        //选择照片
        [self _selectPhoto];
    }else if(button.tag == 3){

        [self _location];
    }
    else if(button.tag == 4) {  //显示、隐藏表情

        BOOL isFirstResponder = _textView.isFirstResponder;

        //输入框是否是第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder) {
            //隐藏键盘
            [_textView resignFirstResponder];
            //显示表情
            [self _showFaceView];
            //隐藏键盘

        } else {
            //隐藏表情
            [self _hideFaceView];

            //显示键盘
            [_textView becomeFirstResponder];
        }

    }

}

#pragma mark - 选择图片
- (void)_selectPhoto{
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pc.delegate = self; //签2协议, 监听选中图片

    [self presentViewController:pc animated:YES completion:nil];

}

//UIImagePickerController 代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    _selectImage = info[UIImagePickerControllerOriginalImage];

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 点击按钮显示/隐藏表情列表
- (void)_showFaceView{

    //创建表情面板
    if (_faceViewPanel == nil) {


        _faceViewPanel = [[FaceScrollView alloc] init];
        [_faceViewPanel setFaceViewDelegate:self];
        //放到底部 (因为父视图是view,导航栏不透明)
        _faceViewPanel.y  = kScreenHeight-64;
        [self.view addSubview:_faceViewPanel];
    }

    //显示表情
    [UIView animateWithDuration:0.3 animations:^{

        _faceViewPanel.bottom = kScreenHeight-64;
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPanel.y;

    }];
}

//隐藏表情
- (void)_hideFaceView {

    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.y = kScreenHeight-64;

    }];

}


- (void)faceDidSelect:(NSString *)text{
    _textView.text = [_textView.text stringByAppendingString:text];
    
}


#pragma mark - 点击按钮显示所在地位置
- (void)_location{


    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {

            //获取授权使用地理位置服务
            [_locationManager requestWhenInUseAuthorization];

        }

    }
    //设置定位精确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

}
//代理 获取定位数据
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{

    //停止定位
    [_locationManager stopUpdatingLocation];

    //取得位置信息
    CLLocation *location = [locations lastObject];

//    CLLocationCoordinate2D coordinate = location.coordinate;
//    NSLog(@"经度%lf,纬度%lf",coordinate.longitude,coordinate.latitude);
//
//    //新浪位置反编码接口http://open.weibo.com/wiki/2/location/geo/geo_to_address
//
//    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:coordinateStr forKey:@"coordinate"];

    __weak SendViewController* weakSelf = self;

//    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
//        NSLog(@"%@",result);
//
//        __strong SendViewController *strongSelf = weakSelf;
//
//        NSArray *geos = [result objectForKey:@"geos"];
//        if (geos.count > 0) {
//            NSDictionary *geo = [geos lastObject];
//
//            NSString *addr = [geo objectForKey:@"address"];
//            NSLog(@"%@",addr);
//
//            strongSelf->_locationLabel.hidden = NO;
//            strongSelf->_locationLabel.text = addr;
//
//        }
//
//    }];

    //iOS自己内置(高德地图)

    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *place = [placemarks lastObject];
//        NSLog(@"%@",place.name);
        __strong SendViewController *strongSelf = weakSelf;
        strongSelf->_locationLabel.hidden = NO;
        strongSelf->_locationLabel.text = place.name;
//        NSLog(@"------~~111~----~~~---~~~---");

    }];



//    NSLog(@"------~~~----~~~---~~~---");
}






#pragma mark - 键盘Frame改变通知-调用方法

- (void)keyBoardWillShow:(NSNotification *)notification{

    NSLog(@"%@",notification);
    // 得到键盘frame
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [bounsValue CGRectValue];

    // 调整工具栏的高度
    _editorBar.bottom = frame.origin.y - 64;

}


#pragma mark - viewWillAppear/disAppear 弹出键盘 收回键盘
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [_textView becomeFirstResponder];



}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
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
