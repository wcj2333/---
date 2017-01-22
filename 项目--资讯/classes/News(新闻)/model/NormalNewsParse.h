//
//  NormalNewsParse.h
//  项目--资讯
//
//  Created by mis on 16/9/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormalNewsParse : NSObject

@property (nonatomic) NSString *body;
@property (nonatomic) NSArray *img;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *ptime;
@property (nonatomic) NSURL *shareLink;

-(instancetype)initWithParseNewsContentWithDic:(NSDictionary *)dic;

@end
