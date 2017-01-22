//
//  SettingTableViewController.h
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myBlock) (id obj);

@interface SettingTableViewController : UITableViewController

@property (nonatomic) myBlock callBack;

@end
