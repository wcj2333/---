//
//  CurrentBmobUser.m
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CurrentBmobUser.h"

@implementation CurrentBmobUser

-(instancetype)initWithBmobUser:(BmobUser *)user{
    if (self = [super init]) {
        self.userName = user.username;
        self.headIVName = [user objectForKey:@"headPath"];
        self.nick = [user objectForKey:@"nick"];
        self.bgIVName = [user objectForKey:@"bgPath"];
        self.gender = [user objectForKey:@"gender"];
        self.birthday = [user objectForKey:@"birthday"];
    }
    return self ;
}

@end
