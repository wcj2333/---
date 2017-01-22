//
//  HeadImgeNews.h
//  项目--资讯
//
//  Created by mis on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HeadImgeNews : JSONModel

//小图
@property (nonatomic) NSString *timgurl;
//大图
@property (nonatomic) NSString *imgurl;
@property (nonatomic) NSString *note;
@property (nonatomic) NSString *photoid;


@end
