//
//  UserView.h
//  微博
//
//  Created by CLAY on 16/5/18.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface UserView : UIView
@property (nonatomic,strong) WeiboModel *weiboModel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end
