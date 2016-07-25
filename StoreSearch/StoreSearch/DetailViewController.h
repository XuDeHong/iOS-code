//
//  DetailViewController.h
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/23.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResult;

typedef NS_ENUM(NSUInteger,DetailViewControllerAnimationType) {
    DetailViewControllerAnimationTypeSlide,
    DetailViewControllerAnimationTypeFade
};

@interface DetailViewController : UIViewController

@property (nonatomic,strong) SearchResult *searchResult;

-(void)presentInParentViewController:(UIViewController *)parentViewController;
-(void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType;

@end
