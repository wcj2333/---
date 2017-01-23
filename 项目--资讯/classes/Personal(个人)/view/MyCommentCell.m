//
//  MyCommentCell.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "MyCommentCell.h"
#import "UIView+Extend.h"
#import "MyCommentNewsView.h"

@implementation MyCommentCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!self.textLB) {
        self.textLB = [[UILabel alloc]initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.headIV.frame)+8, MainScreenW-2*Margin, 0)];
        //self.textLB.backgroundColor = [UIColor redColor];
        self.textLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:self.textLB];
    }
    if (!self.commentIV) {
        self.commentIV = [[UIImageView alloc]initWithFrame:CGRectMake(Margin,0, 150, 100)];
        [self addSubview:self.commentIV];
    }
    if (!self.commentNewsView) {
        //获取xib
        self.commentNewsView = [[NSBundle mainBundle]loadNibNamed:@"MyCommentNewsView" owner:nil options:nil].lastObject;
        self.commentNewsView.frame = CGRectMake(0, 0, MainScreenW, 80);
        [self addSubview:self.commentNewsView];
    }
    self.textLB.font = [UIFont systemFontOfSize:14];
    
}


-(void)setModel:(BmobModel *)model{
    _model = model;
    
    self.commentNewsView.albumPath = model.albumPath;
    self.commentNewsView.countNum = self.countNum;
    self.commentNewsView.source = self.model.source;
    
    BmobUser *user = model.user;
    if ([user objectForKey:@"nick"]) {
        self.nickLB.text = [user objectForKey:@"nick"];
    }else{
        self.nickLB.text = user.username;
    }
    if ([user objectForKey:@"headPath"]) {
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"头像"]];
    }else{
        self.headIV.image = [UIImage imageNamed:@"头像"];
    }
    
    self.detailLB.text = [NSString stringWithFormat:@"介橙用户  %@",[self createTime:model.createAt]];
    
    //标签内容
    NSString *text = model.text;
    
    if (text.length>0&&![text isEqualToString:@""]) {//有文本内容
        self.textLB.text = text;
        
    }else{
        self.textLB.text = @"[发表了一张图片]";
    }
    /*
     重新设置一下标签的宽
     */
    self.textLB.width = MainScreenW-2*Margin;
    self.textLB.numberOfLines = 0;
    [self.textLB sizeToFit];
    
    if (model.imagePath) {//有图片
        self.commentIV.hidden = NO;
        /*
         重新设置一下图片的位置
         */
        CGRect frame = self.commentIV.frame;
        frame.origin.y = CGRectGetMaxY(self.textLB.frame)+3;
        self.commentIV.frame = frame;
        [self.commentIV sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
    }else{
        self.commentIV.hidden = YES;
    }
    
    [self cellHeight];
    
    UIView *lineView = nil;
    if (model.imagePath) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.commentIV.frame)+4, MainScreenW, 1)];
    }else{
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textLB.frame)+4, MainScreenW, 1)];
    }
    lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [self addSubview:lineView];
    
    //评论的新闻
    self.commentNewsView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), MainScreenW, 80);
    
    
}

//cell高度
-(float)cellHeight{
    if (self.model.imagePath) {//有图片
        _cellHeight = self.headIV.height + self.textLB.height + self.commentIV.height+19;
    }else{
        _cellHeight = self.headIV.height + self.textLB.height + 16;
    }
    
    return _cellHeight;
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

-(void)setNewsParse:(NormalNewsParse *)newsParse{
    _newsParse = newsParse;
    self.commentNewsView.model = newsParse;
}
-(void)setPhotosets:(NSArray *)photosets{
    _photosets = photosets;
    self.commentNewsView.photosets = photosets;
}

@end
