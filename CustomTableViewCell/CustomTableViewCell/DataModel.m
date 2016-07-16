//
//  DataModel.m
//  CustomTableViewCell
//
//  Created by 许德鸿 on 16/7/16.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(DataModel *)initWithDictionary:(NSDictionary *)dic
{
    if((self = [super init]))
    {
        self.profileImage = dic[@"profileImage"];
        self.userName = dic[@"userName"];
        self.talkContent = dic[@"talkContent"];
        self.lastTime = dic[@"lastTime"];
    }
    return self;
}

+(DataModel *)dataModelWithDictionary:(NSDictionary *)dic
{
    DataModel *data = [[DataModel alloc]initWithDictionary:dic];
    return data;
}

@end
