//
//  LanscapeViewController.h
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/24.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Search;

@interface LandscapeViewController : UIViewController

@property (nonatomic,strong)Search *search;

-(void)searchResultsReceived;

@end
