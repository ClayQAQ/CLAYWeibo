//
//  WeiboModel.h
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface WeiboModel : BaseModel

@property(nonatomic,copy)NSString       *createDate;       //微博创建时间
@property(nonatomic,strong)NSNumber     *weiboId;           //微博ID
@property(nonatomic,copy)NSString       *text;              //微博的内容
@property(nonatomic,copy)NSString       *source;              //微博来源
@property(nonatomic,strong)NSNumber     *favorited;         //是否已收藏
@property(nonatomic,copy)NSString       *thumbnailImage;     //缩略图片地址
@property(nonatomic,copy)NSString       *bmiddlelImage;     //中等尺寸图片地址
@property(nonatomic,copy)NSString       *originalImage;     //原始图片地址
@property(nonatomic,strong)NSDictionary *geo;               //地理信息字段
@property(nonatomic,strong)NSNumber     *repostsCount;      //转发数
@property(nonatomic,strong)NSNumber     *commentsCount;      //评论数

@property(nonatomic,copy)NSString      *weiboIdStr; //string类型的id

@property (nonatomic,strong) UserModel *userModel; //用户信息

@property (nonatomic,strong) WeiboModel *reWeiboModel;//被转发的微博


@end
