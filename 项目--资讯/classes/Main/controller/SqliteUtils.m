//
//  SqliteUtils.m
//  项目--资讯
//
//  Created by mis on 16/9/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SqliteUtils.h"

static SqliteUtils *_manager = nil;
@implementation SqliteUtils

//单例
+(SqliteUtils *)shareManager{
    if (!_manager) {
        _manager = [[SqliteUtils alloc]init];
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/news.db"];
        _manager.queue = [FMDatabaseQueue databaseQueueWithPath:path];
        //创建数据库表
        //[_manager createTable];
    }
    return _manager;
}

-(void)createTable{
    [self.queue inDatabase:^(FMDatabase *db) {
        //新闻评论数据库
        BOOL b = [db executeUpdate:@"create table if not exists news (pid integer primary key autoincrement, title text, source text,imgsrc text,docid text,TAG text)"];
        if (b) {
            NSLog(@"创建成功");
        }
        
        //离线缓存新闻
        
        
    }];
}

-(void)savaPersonWithPerson:(HeadLineNews *)news{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *string = [NSString stringWithFormat:@"insert into news (title, source,imgsrc,docid,TAG) values('%@','%@','%@','%@','%@')",news.title,news.source,news.imgsrc,news.docid,news.TAG];
        BOOL b = [db executeUpdate:string];
        if (b) {
            NSLog(@"插入成功");
        }
    }];
}

-(void)removeWithPerson:(HeadLineNews *)news{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sqlString = [NSString stringWithFormat:@"delete from news where docid = '%@'",news.docid];
        BOOL b = [db executeUpdate:sqlString];
        if (b) {
            NSLog(@"删除成功");
        }
    }];
}

-(void)findAllPersons:(myBlock)personInfos{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *newsArr = [NSMutableArray array];
        FMResultSet *result = [db executeQuery:@"select * from news"];
        while ([result next]) {
            //将获取的数据库中的信息赋给person 成为一条数据 之后保存起来
            HeadLineNews *news = [[HeadLineNews alloc]initWithResult:result];
            //将每一条数据存入数组中
            [newsArr addObject:news];
            //将数组传递
            personInfos(newsArr);
        }
        if (newsArr.count == 0) {
            personInfos(nil);
        }
    }];
    
}


@end
