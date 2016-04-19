//
//  Checklist.m
//  CheckLists
//
//  Created by 许德鸿 on 16/1/25.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "Checklist.h"

@implementation Checklist
-(id)init
{
    if((self=[super init]))
    {
        self.items=[[NSMutableArray alloc]initWithCapacity:20];
        self.iconName=@"No Icon";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self=[super init]))
    {
        self.name=[aDecoder decodeObjectForKey:@"Name"];
        self.items=[aDecoder decodeObjectForKey:@"Items"];
        self.iconName=[aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

-(int)countUncheckedItems
{
    int count=0;
    for(ChecklistItem *item in self.items)
    {
        if(!item.checked)
            count+=1;
    }
    return count;
}

-(NSComparisonResult)compare:(Checklist*)otherChecklist
{
    return [self.name localizedCaseInsensitiveCompare:otherChecklist.name];
}
@end
