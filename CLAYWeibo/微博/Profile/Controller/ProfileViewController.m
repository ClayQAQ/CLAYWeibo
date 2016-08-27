//
//  ProfileViewController.m
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@interface ProfileViewController ()<SinaWeiboRequestDelegate>

@end

@implementation ProfileViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBothSidesNavItem];
    [self _loadUserData];

}

#pragma mark - 请求用户信息
- (void)_loadUserData{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *weibo = app.sinaweibo;;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"CLAYWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    NSNumber *userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    //将token添加到请求参数中
    [params setObject:accessToken forKey:@"access_token"];
    [params setObject:userID forKey:@"uid"];

    [weibo requestWithURL:user_show params:params httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
//    NSLog(@"%@",result);
    UserModel *user = [[UserModel alloc] init];
    [user setValuesForKeysWithDictionary:result];
    _userName.text = user.screen_name;
    self.title = user.screen_name;
    
    _userName.color = @"Profile_BG_Text_color";
    [_userImage sd_setImageWithURL:[NSURL URLWithString:user.avatar_large] placeholderImage:[UIImage imageNamed:@"icon"]];
    _weiboCount.text = user.statuses_count.stringValue;
    _weiboCount.color = @"Profile_4Button_Num_color";
    _friendsCount.text = user.friends_count.stringValue;
    _friendsCount.color = @"Profile_4Button_Num_color";
    _followersCount.text = user.followers_count.stringValue;
    _followersCount.color = @"Profile_4Button_Num_color";

    _weiboLabel.color = @"Profile_4Button_Text_color";
    _friendsLabel.color = @"Profile_4Button_Text_color";
    _followersLabel.color = @"Profile_4Button_Text_color";

    _userDescription.text = [NSString stringWithFormat:@"个性签名:  %@",user.userDescription];
    _userDescription.color = @"Profile_4Button_Text_color";

}

#pragma mark - 每次到此界面都更新数据  ( url&时间戳? )
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self _loadUserData];  



}



@end
