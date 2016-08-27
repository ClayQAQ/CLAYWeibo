//
//  UserModel.m
//  微博
//
//  Created by CLAY on 16/5/14.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

// 这个Model的处理 ,直接用KVC ,不用BaseModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {

        _userDescription = value;


    }
}

@end
