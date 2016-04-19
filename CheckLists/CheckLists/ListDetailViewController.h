//
//  ListDetailViewController.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/26.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checklist.h"
#import "IconPickerViewController.h"

@class ListDetailViewController;
@class Checklist;
@protocol ListDetailViewControllerDelegate <NSObject>

-(void)ListDetailViewControllerDidCancel:(ListDetailViewController*)controller;
-(void)ListDetailViewController:(ListDetailViewController*)controller didFinishAddingChecklist:(Checklist *)checklist;
-(void)ListDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;
@end

@interface ListDetailViewController : UITableViewController<UITextFieldDelegate,IconPickerViewControllerDelegate>


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic,weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic,weak) Checklist *checklistToEdit;
@end
