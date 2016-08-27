//
//  ScaleImageView.m
//  微博
//
//  Created by CLAY on 16/5/18.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "ScaleImageView.h"
#import "DDProgressView.h"
#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
#import "UIView+ViewController.h"

@implementation ScaleImageView{
    NSURLSessionDataTask *_task;
    double _length;//总长度
    NSMutableData *_data;//下载的数据
    DDProgressView *_progressView;
    UIAlertController *_alert;
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return  self;


}
- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return  self;
}
#warning    gif处理
- (void)_createGifIcon{

    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.hidden = YES;
    _iconImageView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconImageView];




}




- (void)_initTap{
    //01 打开交互
    self.userInteractionEnabled = YES;

    //02 创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];

    [self addGestureRecognizer:tap];

    //03 设置显示 模式,等比例
    self.contentMode = UIViewContentModeScaleAspectFit;

    //04 设置警告视图控制器
    _alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [_alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImage *img = [UIImage imageWithData:_data];
            //1.提示保存
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.labelText = @"正在保存";
            hud.dimBackground = YES;

            //2.将大图图片保存到相册
            //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
        }]];
    [_alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];






}

- (void)zoomIn{

    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {

        [self.delegate imageWillZoomIn:self];

    }



    /**
     01 隐藏原图
     */
    self.hidden = YES;

    //02 创建大图浏览_scrollView
    [self _createView];

    //03 计算_fullImageView的Frame
    //计算出 小图 self 相对于 window的坐标
    CGRect frame = [self convertRect:self.bounds  toView:self.window];
    _fullImageView.frame = frame;

    //04 放大图片动画
    [UIView animateWithDuration:0.3 animations:^{

        _fullImageView.frame = _scrollView.bounds;

    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];


    }];


    //05 请求网络 下载大图,没有则下载中图!  //请求的cachePolicy:选择了不缓存
    // full/mid ImageUrlString在WeiboView.m填充
    if (self.fullImageUrlString.length > 0) {

        NSURL *url = [NSURL URLWithString:self.fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _task = [session dataTaskWithRequest:request];
        [_task resume];



    }else if (self.midImageString.length > 0){
        NSURL *url = [NSURL URLWithString:self.midImageString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _task = [session dataTaskWithRequest:request];
        [_task resume];

    }

}

- (void)zoomOut{

    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {

        [self.delegate imageWillZoomOut:self];

    }




    //取消网络下载
    [_task cancel];

    //缩小动画效果
    self.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.backgroundColor = [UIColor clearColor];
                         CGRect frame = [self convertRect:self.bounds  toView:self.window];
                         _fullImageView.frame = frame;


                     } completion:^(BOOL finished) {

                         [_scrollView removeFromSuperview];
                         _scrollView = nil;
                         _fullImageView = nil;
                         _progressView = nil;
                         //清空_data ,其为容器,所以要慎重
                         _data = nil;
                     }];


}



- (void)_createView{
    if (_scrollView == nil) {

        //1 创建scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];

        //2 创建大图图片
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];


        //3 添加手势
        //01 单击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];

        [_scrollView addGestureRecognizer:tap];

#warning ----长按手势添加保存相片
        //02 长按 保存
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
        // longPress.minimumPressDuration = 1.5;
        [_scrollView addGestureRecognizer:longPress];




        //4 添加进度条
        _progressView = [[DDProgressView alloc] init];
        _progressView.frame = CGRectMake(10, kScreenHeight/2, kScreenWidth-20, 50);
        _progressView.outerColor = [UIColor yellowColor];
        _progressView.innerColor = [UIColor lightGrayColor];
        _progressView.emptyColor = [UIColor darkGrayColor];
        _progressView.hidden = YES;

        [_scrollView addSubview:_progressView];

    }

}

#pragma mark - 长按图片处理,弹出警告控制器sheet
- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{

    if (longPress.state == UIGestureRecognizerStateBegan) {
        //响应者链找到self向上找,所在的第一个控制器 ,scrollView挡住了_alert
        [self.viewController presentViewController:_alert animated:YES completion:^{
//            _scrollView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//            _fullImageView.transform = CGAffineTransformMakeTranslation(_fullImageView.left, _fullImageView.top-60) ;
            self.hidden = NO;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _scrollView.backgroundColor = [UIColor clearColor];
                                 CGRect frame = [self convertRect:self.bounds  toView:self.window];
                                 _fullImageView.frame = frame;


                             } completion:^(BOOL finished) {

                                 [_scrollView removeFromSuperview];
                                 _scrollView = nil;
                                 _fullImageView = nil;
                                 _progressView = nil;
//                                 _data = nil;
                             }];



        }];
    }









}



//此方法的调用 在点击zoomIn方法中的_alert设置中 (点击sheet的"Default确定" )

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    //提示保存成功
    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);

    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";

    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
#warning  ______ 清空_data   ____
   //清空_data
    _data = nil;
}

#pragma - mark  网络代理
//服务器对请求的反馈
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    //响应 ，length
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //01 取得响应头信息
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];

    //02 从响应头获取长度
    NSString *size = [allHeaderFields objectForKey:@"Content-Length"];

    _length = [size doubleValue];

    _data = [[NSMutableData alloc] init];
    _progressView.hidden = NO;



    //允许处理response
    completionHandler(NSURLSessionResponseAllow);
}

//下载数据
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{

    [_data appendData:data];
    CGFloat progress = _data.length/_length;
    _progressView.progress = progress;

}

// 下载完成
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    _progressView.hidden = YES;

    UIImage *image = [UIImage imageWithData:_data];
    // 不管原图/中图 只要有图就给他 <反正创建下载是优先下载原图>
    _fullImageView.image = image;


    //处理imageView尺寸
    //等比例拉伸:  拉伸后图片的长/图片的宽 ==  ImageView原长/屏幕宽.
    [UIView animateWithDuration:0.5 animations:^{

        CGFloat length = image.size.height/image.size.width * kScreenWidth;
        if (length < kScreenHeight) {
            _fullImageView.y = (kScreenHeight-length)/2;
        }
        _fullImageView.height = length;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, length);


    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];

    }];

    if (self.isGif) {
        [self gifImageShow];
    }
    


}


- (void)gifImageShow{
    //1.-----------------webView播放---------------------
    //            UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
    //            webView.userInteractionEnabled = NO;
    //            webView.backgroundColor = [UIColor clearColor];
    //            webView.scalesPageToFit = YES;
    //
    //            //使用webView加载图片数据
    //            [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //            [_scrollView addSubview:webView];


    //2. ---------使用ImageIO 提取GIF中所有帧的图片进行播放---------------
    //#import <ImageIO/ImageIO.h>

    //
    //    //1>创建图片源
    //    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(_data), NULL);
    //
    //    //2>获取图片源中图片的个数
    //    size_t count = CGImageSourceGetCount(source);
    //
    //    NSMutableArray *images = [NSMutableArray array];
    //
    //    NSTimeInterval duration = 0;
    //
    //    for (size_t i=0; i<count; i++) {
    //
    //        //3>取得每一张图片
    //        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
    //        UIImage *uiImg = [UIImage imageWithCGImage:image];
    //        [images addObject:uiImg];
    //
    //        //0.1 是一帧播放的时间，累加每一帧的时间
    //        duration += 0.1;
    //    }
    //
    //    //>4-1.或者将所有帧的图片集成到一个动画UIImage对象中
    //    UIImage *imgs = [UIImage animatedImageWithImages:images duration:duration];
    //    _fullImageView.image = imgs;
    //
    //    //        //>4-2.或者将播放的图片组交给_fullImageView播放
    //    //        _fullImageView.animationImages = images;
    //    //        _fullImageView.animationDuration = duration;
    //    //        [_fullImageView startAnimating];
    
    
    //3 -------------SDWebImage 封装的GIF播放------------------
    //#import "UIImage+GIF.h"
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    
}





@end
