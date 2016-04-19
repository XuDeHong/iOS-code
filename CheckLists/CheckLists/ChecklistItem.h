//
//  ChecklistItem.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/19.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModal.h"
#import <UIKit/UIKit.h>

@interface ChecklistItem : NSObject<NSCoding>
-(void) toggleChecked;
-(void) scheduleNotification;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,assign)BOOL checked;
@property(nonatomic,copy)NSDate *dueDate;
@property(nonatomic,assign)BOOL shouldRemind;
@property(nonatomic,assign)NSInteger itemId;
@end
