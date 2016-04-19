//
//  ItemDetailViewController.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/20.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChecklistItem.h"

@class ItemDetailViewController;
@class ChecklistItem;
@protocol ItemDetailViewControllerDelegate <NSObject>

-(void)ItemDetailViewControllerDidCancel:(ItemDetailViewController*)controller;
-(void)ItemDetailViewController:(ItemDetailViewController*)controller didFinishAddingItem:(ChecklistItem *)item;
-(void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

@end

@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic,weak) IBOutlet UISwitch *switchControl;
@property (nonatomic,weak) IBOutlet UILabel *dueDateLabel;
@property (nonatomic,weak) id <ItemDetailViewControllerDelegate> delegate;
@property (nonatomic,weak) ChecklistItem *itemToEdit;
@end
