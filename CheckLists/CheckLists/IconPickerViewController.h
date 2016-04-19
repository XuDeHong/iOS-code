//
//  IconPickerViewController.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/30.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController
@property(nonatomic,weak)id <IconPickerViewControllerDelegate>delegate;
@end
