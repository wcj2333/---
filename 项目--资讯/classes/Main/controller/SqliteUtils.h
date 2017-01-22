//
//  SqliteUtils.h
//  项目--资讯
//
//  Created by mis on 16/9/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "HeadLineNews.h"

typedef void(^myBlock)(id object);

@interface SqliteUtils : NSObject
@property (nonatomic) FMDatabaseQueue *queue;

//关于数据库的操作
+(SqliteUtils *)shareManager;
//创建表
-(void)createTable;
//插入数据
-(void)savaPersonWithPerson:(HeadLineNews *)news;
//删除
-(void)removeWithPerson:(HeadLineNews *)news;
//查找所有
-(void)findAllPersons:(myBlock)personInfos;


@end
