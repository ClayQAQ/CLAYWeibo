//
//  DataService.m
//  微博
//
//  Created by CLAY on 16/5/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "DataService.h"

#import "JSONKit.h"

@implementation DataService

+ (void)requestUrl:(NSString *)urlString httpMethod:(NSString *)method params:(NSMutableDictionary *)params block:(BlockType)block{
    //0.取得本地保存的token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"CLAYWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];

    //将token添加到请求参数中
    [params setObject:accessToken forKey:@"access_token"];

    //01 构建url

    NSString *fullString = [BaseUrl stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:fullString];


    //02 构造request

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:method];


    //03 拼接参数
    NSArray *allKeys = [params allKeys];
    NSMutableString   *paramString = [[NSMutableString alloc] init];
    for (int i = 0; i<allKeys.count; i++) {

        NSString *key = allKeys[i];
        NSString *value = [params objectForKey:key];

        [paramString  appendFormat:@"%@=%@",key,value];

        if (i < allKeys.count-1) {
            [paramString appendString:@"&"];
        }
    }
    //>>02 JSON字符串
    //JSONKit 转换，目前 jsonkit 已经不更新，丢弃
    NSString *jsonString = [params JSONString];
    NSLog(@"%@",jsonString);

    //如果是 GET请求 ，则把参数拼接到url里面
    if ([method isEqualToString:@"GET"]) {
        //query url里面的参数
        NSString *seperation = url.query?@"&":@"?";
        NSString *paraUrlString = [NSString stringWithFormat:@"%@%@%@",fullString,seperation,paramString];

        request.URL = [NSURL URLWithString:paraUrlString];

    }else if([method isEqualToString:@"POST"]){
        //则把参数放到 body里

        NSData *data = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];

    }

    //04 connection请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //数据接收完毕 处理数据
        if (connectionError != nil) {
            NSLog(@"网络请求失败 ");
        }

        //原生
        //  id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        //jsonkit 解析
        id result = [data objectFromJSONData];


        //把数据传递给界面
        if (block) {
            block(result);
        }


    }];

}


+ (AFHTTPRequestOperation *)requestAFUrl:(NSString *)urlString
                              httpMethod:(NSString *)method
                                  params:(NSMutableDictionary *)params //token  文本
                                    data:(NSMutableDictionary *)datas //文件
                                   block:(BlockType)block{

    //0.取得本地保存的token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"CLAYWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];

    //将token添加到请求参数中
    [params setObject:accessToken forKey:@"access_token"];



    //01 构建urlString
    NSString *fullUrlString = [BaseUrl stringByAppendingString:urlString];

    //02 构建manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    // manager.responseSerializer
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    if ([method isEqualToString:@"GET"]) {
        AFHTTPRequestOperation *operation =  [manager GET:fullUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"传输失败 ");
        }];
        return  operation;

    }else if([method isEqualToString:@"POST"]){
        //datas存储图片 相关信息
        if (datas != nil) {

            AFHTTPRequestOperation *operation = [manager POST:fullUrlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //图片添加到body 就由这个block来完成
                for (NSString *name in datas) {
                    NSData *data = [datas objectForKey:name];
                    [formData appendPartWithFileData:data name:name fileName:@"1.png" mimeType:@"image/jpeg"];
                }

            } success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSLog(@"上传成功");

                block(responseObject);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"上传失败");
            }];

            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"上传进度,已经上传 %lld",totalBytesWritten);


            }];
            return  operation;

        }else{//不带图片

            AFHTTPRequestOperation *operation =  [manager POST:fullUrlString parameters:params success:^void(AFHTTPRequestOperation *operation , id responseObject ) {
                NSLog(@"POST成功");

                block(responseObject);

            } failure:^void(AFHTTPRequestOperation *operation, NSError *error) {

            }];

            return  operation;

        }

    }
    return nil;
}

+ (void)getHomeList:(NSMutableDictionary *)params
              block:(BlockType)block{

    [DataService requestUrl:home_timeline httpMethod:@"GET" params:params block:block];


}

+ (void)sendWeibo:(NSMutableDictionary *)params
            block:(BlockType)block{

    [DataService requestUrl:send_update httpMethod:@"POST" params:params block:block];

}




+ (AFHTTPRequestOperation *)sendWeibo:(NSString *)text
                                image:(UIImage *)image
                                block:(BlockType)block{
    if (text == nil) {
        return nil;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:text forKey:@"status"];
    //01 如果只是文本
    if (image == nil) {

        return  [DataService requestAFUrl:send_update httpMethod:@"POST" params:params data:nil block:block];

    }


    //02 带图片
    NSData *data = UIImageJPEGRepresentation(image, 1);

    //如果大于2M 则压缩
    if (data.length > 1024*1024*2) {

        data = UIImageJPEGRepresentation(image, 0.5);
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:data forKey:@"pic"];
    
    return [DataService requestAFUrl:send_upload httpMethod:@"POST" params:params data:dataDic block:block];
    
    
    
}

@end
