//
//  LeftMenuView.h
//  StoreManager
//
//  Created by 王陈洁 on 16/10/17.
//  Copyright © 2016年 hare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewDelegate <NSObject>

-(void)sendArticle;

@end

@interface LeftMenuView : UIView

@property (nonatomic) NSArray *menus;
@property (nonatomic) UIImageView *iv;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSMutableArray *titles;

@property (nonatomic) id<LeftMenuViewDelegate> leftMenuViewDelegate;

@end
