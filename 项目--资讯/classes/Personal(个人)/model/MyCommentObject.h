//
//  MyCommentObject.h
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentObject : NSObject

@property (nonatomic) NSString *source;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *headPath;
@property (nonatomic) NSString *nick;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
