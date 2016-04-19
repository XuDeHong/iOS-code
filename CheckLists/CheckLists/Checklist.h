//
//  Checklist.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/25.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChecklistItem.h"

@interface Checklist : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,copy)NSString *iconName;
-(int)countUncheckedItems;
@end
