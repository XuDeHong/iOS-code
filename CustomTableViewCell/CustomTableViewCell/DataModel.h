//
//  DataModel.h
//  CustomTableViewCell
//
//  Created by 许德鸿 on 16/7/16.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,copy) NSString *profileImage;  //用户头像
@property (nonatomic,copy) NSString *userName;      //用户名称
@property (nonatomic,copy) NSString *talkContent;   //聊天内容
@property (nonatomic,copy) NSString *lastTime;      //聊天时间

-(DataModel *)initWithDictionary:(NSDictionary *)dic;   //初始化方法
+(DataModel *)dataModelWithDictionary:(NSDictionary *)dic;  //初始化类方法

@end
