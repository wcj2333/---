//
//  PersonalTableViewController.h
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewController : UITableViewController

@property (nonatomic) NSString *userName;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSString *isActiveTimer;
@property (nonatomic) long currentTime;

@end
