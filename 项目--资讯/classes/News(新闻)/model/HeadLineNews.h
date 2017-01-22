//
//  HeadLineNews.h
//  项目--资讯
//
//  Created by mis on 16/9/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FMDB.h"

@interface HeadLineNews : JSONModel

@property (nonatomic) NSNumber<Ignore>* pid;

@property (nonatomic) NSArray<Optional> *dingyue;

//标题
@property (nonatomic) NSString *title;
//提交时间
@property (nonatomic) NSString<Optional> *lmodify;
//图片地址
@property (nonatomic) NSString<Optional> *imgsrc;
//新闻信息
@property (nonatomic)NSString<Optional> *recSource;
//轮播页的图片
@property (nonatomic)NSArray<Optional> *ads;
//是否是视频
@property (nonatomic)NSString<Optional> *TAG;
//视频ID
@property (nonatomic) NSString<Optional> *videoID;
@property (nonatomic) NSDictionary<Optional> *videoinfo;
//来源
@property (nonatomic)NSString<Optional> *source;
//多图吧...
@property (nonatomic)NSArray<Optional> *imgnewextra;
@property (nonatomic)NSString<Optional> *skipID;



@property (strong, nonatomic) NSArray<Optional> *unlikeReason;

@property (copy, nonatomic) NSString<Optional> *recReason;

@property (copy, nonatomic) NSString<Optional> *specialID;

@property (copy, nonatomic) NSString<Optional> *specialtip;

@property (strong, nonatomic) NSDictionary<Optional> *live_info;

@property (copy, nonatomic) NSString<Optional> *specialadlogo;

@property (copy, nonatomic) NSString<Optional> *tname;

@property (copy, nonatomic) NSString<Optional> *hasImg;
@property (copy, nonatomic) NSString<Optional> *cid;

@property (copy, nonatomic) NSString<Optional> *ename;

@property (copy, nonatomic) NSString<Optional> *url_3w;

@property (copy, nonatomic) NSString<Optional> *boardid;

@property (copy, nonatomic) NSString<Optional> *url;

@property (copy, nonatomic) NSString<Optional> *order;

@property (copy, nonatomic) NSString<Optional> *alias;

@property (copy, nonatomic) NSString<Optional> *priority;

@property (copy, nonatomic) NSString<Optional> *votecount;

//@property (copy, nonatomic) NSString<Optional> *editor;


@property (copy, nonatomic) NSString<Optional> *template;

@property (copy, nonatomic) NSString<Optional> *ptime;

@property (copy, nonatomic) NSString<Optional> *program;

@property (copy, nonatomic) NSString<Optional> *interest;
/**内容的类型标识*/
@property (copy, nonatomic) NSString<Optional> *tag;

@property (copy, nonatomic) NSString<Optional> *skipType;
/**图片内容的标识*/
@property (copy, nonatomic) NSString<Optional> *photosetID;

@property (copy, nonatomic) NSString<Optional> *hasHead;

@property (copy, nonatomic) NSString<Optional> *prompt;

@property (copy, nonatomic) NSString<Optional> *pixel;

@property (copy, nonatomic) NSString<Optional> *videosource;

/**图片数组*/
@property (strong, nonatomic) NSArray<Optional> *imgextra;

/**内容图片URL*/
@property (copy, nonatomic) NSString<Optional> *img;

@property (copy, nonatomic) NSString<Optional> *id;

@property (copy, nonatomic) NSString<Optional> *docid;

@property (copy, nonatomic) NSString<Optional> *subtitle;

/**内容的描述*/
@property (copy, nonatomic) NSString<Optional> *digest;

@property (copy, nonatomic) NSString<Optional> *hasAD;

@property (copy, nonatomic) NSString<Optional> *TAGS;

-(instancetype)initWithResult:(FMResultSet *)result;

@end
