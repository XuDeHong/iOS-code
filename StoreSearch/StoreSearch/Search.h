//
//  Search.h
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/28.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchBlock)(BOOL success);

@interface Search : NSObject

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,readonly,strong) NSMutableArray *searchResults;

-(void)performSelectorForText:(NSString *)text category:(NSInteger)category completion:(SearchBlock)block;

@end
