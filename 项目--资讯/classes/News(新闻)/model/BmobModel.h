//
//  BmobModel.h
//  项目--资讯
//
//  Created by mis on 16/9/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BmobModel : NSObject

@property (nonatomic) BmobUser *user;
@property (nonatomic) NSDate *createAt;
@property (nonatomic) NSString *source;
@property (nonatomic) int commentCount;
@property (nonatomic) BmobGeoPoint *location;
@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSString *text;
@property (nonatomic) BmobObject *obj;
@property (nonatomic) NSString *albumPath;

-(instancetype)initWithObj:(BmobObject *)obj;

@property (nonatomic) float cellHeight;

@end
