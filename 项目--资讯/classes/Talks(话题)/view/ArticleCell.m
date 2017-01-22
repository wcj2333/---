//
//  ArticleCell.m
//  项目--资讯
//
//  Created by mis on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (void)awakeFromNib {
    self.albumIV.layer.masksToBounds = YES;
    self.albumIV.layer.cornerRadius = 5;
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    self.titleLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.nickLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.timeLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}

-(void)setBobj:(BmobObject *)bobj{
    _bobj = bobj;
    self.titleLB.text = [bobj objectForKey:@"title"];
    NSString *albumPath = [bobj objectForKey:@"imagePath"];
    if (albumPath) {//存在
        [self.albumIV sd_setImageWithURL:[NSURL URLWithString:albumPath] placeholderImage:[UIImage imageNamed:@"话题封面.jpg"]];
    }else{
        self.albumIV.image = [UIImage imageNamed:@"话题封面.jpg"];
    }
    BmobUser *user = [bobj objectForKey:@"user"];
    NSString *nick = [user objectForKey:@"nick"];
    if (nick) {
        self.nickLB.text = nick;
    }else{
        self.nickLB.text = user.username;
    }
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.timeLB.text = [self createTime:bobj.createdAt];
    
}

-(NSString *)createTime:(NSDate *)date{
    //得到发送的Date对象
    NSDate *createDate = date;
    NSDate *nowDate = [NSDate new];
    //发送时间
    long createTime = [createDate timeIntervalSince1970];
    //当前时间
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime - createTime;
    
    if (time<60) {
        return @"刚刚";
    }else if (time>=60&&time<3600){
        
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time>=3600&&time<3600*24){
        
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *f = [NSDateFormatter new];
        f.dateFormat = @"MM月dd日 HH:mm";
        return [f stringFromDate:createDate];
        
    }
    
}


@end
