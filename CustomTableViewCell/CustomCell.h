//
//  CustomCell.h
//  CustomTableViewCell
//
//  Created by 许德鸿 on 16/7/16.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *talkContent;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;

@end
