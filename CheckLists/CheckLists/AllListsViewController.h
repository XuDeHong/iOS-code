//
//  AllListsViewController.h
//  CheckLists
//
//  Created by 许德鸿 on 16/1/22.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checklist.h"
#import "ChecklistItem.h"
#import "ViewController.h"
#import "ListDetailViewController.h"
#import "DataModal.h"


@class DataModal;
@interface AllListsViewController : UITableViewController<ListDetailViewControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)DataModal *dataModel;
@end
