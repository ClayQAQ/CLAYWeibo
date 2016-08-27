//
//  BaseModel.h
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//初始化方法,子类Model,设置好映射字典后,调用这个即可
-(id)initWithDataDic:(NSDictionary*)dataDic;

//设置映射字典,子类一般必须复写
- (NSDictionary*)attributeMapDictionary;

//设置属性
- (void)setAttributes:(NSDictionary*)dataDic;

@end
