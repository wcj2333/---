//
//  ModeCell.h
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModeCellDelegate <NSObject>

-(void)chooseModeWithButton:(UIButton *)sender;

@end

@interface ModeCell : UITableViewCell

@property (nonatomic) id<ModeCellDelegate> modeCellDelegate;

@end
