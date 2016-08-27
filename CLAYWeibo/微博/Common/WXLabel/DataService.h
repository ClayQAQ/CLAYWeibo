//
//  DataService.h
//  微博
//
//  Created by CLAY on 16/5/19.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

#define BaseUrl @"https://api.weibo.com/2/"

typedef void(^BlockType)(id result);

@interface DataService : NSObject


+ (void)requestUrl:(NSString *)urlString //url
        httpMethod:(NSString *)method //GET  POST
            params:(NSMutableDictionary *)params //参数
             block:(BlockType)block; //接收到的数据的处理



//上传图片
+ (AFHTTPRequestOperation *)requestAFUrl:(NSString *)urlString
                              httpMethod:(NSString *)method
                                  params:(NSMutableDictionary *)params //token  文本
                                    data:(NSMutableDictionary *)datas //文件
                                   block:(BlockType)block;




//获取微博列表
+ (void)getHomeList:(NSMutableDictionary *)params
              block:(BlockType)block;

//发微博
+ (void)sendWeibo:(NSMutableDictionary *)params
            block:(BlockType)block;



// 发带图片的微博用这个,并且这个有判断是否带图片. 并且内置 UIImage转换成NSData.
+ (AFHTTPRequestOperation *)sendWeibo:(NSString *)text
                                image:(UIImage *)image
                                block:(BlockType)block;


@end
