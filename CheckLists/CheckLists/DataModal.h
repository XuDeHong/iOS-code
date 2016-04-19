//
//  DataModal.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/29.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModal : NSObject
@property(nonatomic,strong)NSMutableArray *lists;
-(void)saveChecklists;
-(NSInteger)indexOfSelectedChecklist;
-(void)setIndexOfSelectedChecklist:(NSInteger)index;
-(void)sortChecklists;
+(NSInteger)nextChecklistItemId;
@end
