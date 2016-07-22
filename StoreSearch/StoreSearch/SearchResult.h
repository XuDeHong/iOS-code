//
//  SearchResult.h
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/20.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *artistName;
@property (nonatomic,copy) NSString *artworkURL60;
@property (nonatomic,copy) NSString *artworkURL100;
@property (nonatomic,copy) NSString *storeURL;
@property (nonatomic,copy) NSString *kind;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSDecimalNumber *price;
@property (nonatomic,copy) NSString *genre;

-(NSComparisonResult)compareName:(SearchResult *)other;

@end
