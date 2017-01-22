//
//  CurrentBmobUser.h
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentBmobUser : NSObject

@property (nonatomic) NSString *userName;
@property (nonatomic) NSURL *headIVName;
@property (nonatomic) NSString *nick;
@property (nonatomic) NSURL *bgIVName;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *birthday;

-(instancetype)initWithBmobUser:(BmobUser *)user;
@end
