//
//  ProfileViewController.h
//  微博
//
//  Created by CLAY on 16/5/12.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "BaseViewController.h"
#import "CLAYLabel.h"

@interface ProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet CLAYLabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet CLAYLabel *weiboCount;
@property (weak, nonatomic) IBOutlet CLAYLabel *friendsCount;
@property (weak, nonatomic) IBOutlet CLAYLabel *followersCount;

@property (weak, nonatomic) IBOutlet CLAYLabel *weiboLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *friendsLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *followersLabel;
@property (weak, nonatomic) IBOutlet CLAYLabel *userDescription;
@end
