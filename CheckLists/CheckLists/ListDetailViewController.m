//
//  ListDetailViewController.m
//  CheckLists
//
//  Created by 许德鸿 on 16/1/26.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "ListDetailViewController.h"


@interface ListDetailViewController ()

@end

@implementation ListDetailViewController
{
    NSString *_iconName;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self=[super initWithCoder:aDecoder]))
    {
        _iconName=@"Folder";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.checklistToEdit!=nil)
    {
        self.title=@"Edit Checklist";
        self.textField.text=self.checklistToEdit.name;
        self.doneBarButton.enabled=YES;
        _iconName=self.checklistToEdit.iconName;
    }
    self.iconImageView.image=[UIImage imageNamed:_iconName];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self.delegate ListDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
    if(self.checklistToEdit==nil)
    {
        Checklist *checklist=[[Checklist alloc]init];
        checklist.name=self.textField.text;
        checklist.iconName=_iconName;
        [self.delegate ListDetailViewController:self didFinishAddingChecklist:checklist];
    }
    else
    {
        self.checklistToEdit.name=self.textField.text;
        self.checklistToEdit.iconName=_iconName;
        [self.delegate ListDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText=[textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled=([newText length]>0);
    return YES;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section==1)
    {
        return indexPath;
    }
    else
        return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PickIcon"])
    {
        IconPickerViewController *controller=segue.destinationViewController;
        controller.delegate=self;
    }
}

-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName
{
    _iconName=iconName;
    self.iconImageView.image=[UIImage imageNamed:_iconName];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
