//
//  MyTabBarController.m
//  MyLocations
//
//  Created by Matthijs on 18-10-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "MyTabBarController.h"

@implementation MyTabBarController

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
  return nil;
}

@end
