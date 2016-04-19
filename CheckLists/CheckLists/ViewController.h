//
//  ViewController.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/15.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checklist.h"
#import "ChecklistItem.h"
#import "ItemDetailViewController.h"


@interface ViewController : UITableViewController<ItemDetailViewControllerDelegate>

//- (IBAction)addItem:(id)sender;
@property(nonatomic,strong)Checklist *checklist;

@end

