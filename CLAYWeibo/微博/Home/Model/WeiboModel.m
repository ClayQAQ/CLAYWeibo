//
//  WeiboModel.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel



//重写. 设置其映射字典
- (NSDictionary*)attributeMapDictionary{

    NSDictionary *dic = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"  //添加此映射
                             };

    return dic;
}




// 复写. 但是必须[super setAttributes:dataDic]; ,还是要用到父类的解析方法. 这里只是完善一下解析方法.
- (void)setAttributes:(NSDictionary *)dataDic{

    //父类这一步 已经把model解析的差不多了 . 下面的都是在此基础上的补充/对属性进一步加工.
    [super setAttributes:dataDic];

#warning 处理_weiboIdStr  因为接口有,所以在attributeMapDictionary 处理
//    _weiboIdStr = _weiboId.stringValue; 选择在上面添加映射

    //处理 微博来源
    //<a href="http://app.weibo.com/t/fee" rel="nofollow">360安全浏览器</a>

    if (self.source != nil) {
        NSString *regex = @">.+<";//>360安全浏览器<

        NSArray *items = [self.source componentsMatchedByRegex:regex];
        if (items.count != 0) {
            NSString *temp = items[0];
            temp = [temp substringWithRange:NSMakeRange(1, temp.length-2)];

            self.source = [NSString stringWithFormat:@"来源:%@",temp];

        }

    }


    //用正则表达式规则 找到 所有的 [xx]
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceItems = [self.text componentsMatchedByRegex:regex];
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceConfigArray = [NSArray arrayWithContentsOfFile:configPath];

    for (NSString *faceName in faceItems) {
        //用谓词进行过滤 在emoticons.plist中找到对应的字典对象!
        NSString *t = [NSString stringWithFormat:@"chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        NSArray *items = [faceConfigArray filteredArrayUsingPredicate:predicate];

        //谓词过滤返回一个数组,但是我们制作的谓词,知道数组肯定只有对应的一个元素!
        if (items.count > 0) {
            // 判断后,数组可以直接用下标取出元素.
            NSDictionary *faceDic  = items[0];

            //通过字典对象属性的get方法,取得图片的名字
            NSString *imageName = [faceDic objectForKey:@"png"];

            NSString *replaceString = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            //text对应表情文本替换,变成可以让WXLabel处理的字符串格式
            self.text =  [self.text stringByReplacingOccurrencesOfString:faceName withString:replaceString];
        }

    }




    // 添加user解析
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    //传来的数据可能user为nil  ,保险起见.
    if (userDic != nil) {

//        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];

        // 不是用BaseModel的 initWithDataDic方法,使用KVC,给类的对象传一个字典
        UserModel *userModel = [[UserModel alloc] init];
        [userModel setValuesForKeysWithDictionary:userDic];

        self.userModel = userModel;

    }

    NSDictionary *reDic = [dataDic objectForKey:@"retweeted_status"];
    if (reDic != nil) {

        self.reWeiboModel = [[WeiboModel alloc] initWithDataDic:reDic];

        //转发内容拼接用户名
        NSString *name = self.reWeiboModel.userModel.screen_name;
        self.reWeiboModel.text = [NSString stringWithFormat:@"@%@: %@",name,self.reWeiboModel.text];
    }

    
}




@end
