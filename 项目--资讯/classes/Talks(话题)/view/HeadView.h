//
//  HeadView.h
//  项目--资讯
//
//  Created by mis on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewDelegate <NSObject>

-(void)chooseAlbumImage;

@end

@interface HeadView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addAlbumBtn;
@property (weak, nonatomic) IBOutlet UIImageView *albumIV;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;

@property (nonatomic) id<HeadViewDelegate> headViewDelegate;

@end
