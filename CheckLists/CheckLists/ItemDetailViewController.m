//
//  ItemDetailViewController.m
//  CheckLists
//
//  Created by 许德鸿 on 16/1/20.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "ItemDetailViewController.h"

@implementation ItemDetailViewController
{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

- (IBAction)cancel:(id)sender {
    [self.delegate ItemDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
    if(self.itemToEdit==nil)
    {
        ChecklistItem *item=[[ChecklistItem alloc]init];
        item.text=self.textField.text;
        item.checked=NO;
        item.shouldRemind=self.switchControl.on;
        item.dueDate=_dueDate;
        [item scheduleNotification];
        [self.delegate ItemDetailViewController:self didFinishAddingItem:item];
    }
    else
    {
        self.itemToEdit.text=self.textField.text;
        self.itemToEdit.shouldRemind=self.switchControl.on;
        self.itemToEdit.dueDate=_dueDate;
        [self.itemToEdit scheduleNotification];
        [self.delegate ItemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText=[textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled=([newText length]>0);
    return YES;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section==1 && indexPath.row==1)
    {
        return indexPath;
    }
    else
        return nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(self.itemToEdit!=nil)
    {
        self.title=@"Edit Item";
        self.textField.text=self.itemToEdit.text;
        self.doneBarButton.enabled=YES;
        self.switchControl.on=self.itemToEdit.shouldRemind;
        _dueDate=self.itemToEdit.dueDate;
    }
    else
    {
        self.switchControl.on=NO;
        _dueDate=[NSDate date];
    }
    [self updateDueDateLabel];
}

-(void)updateDueDateLabel
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text=[formatter stringFromDate:_dueDate];
}

-(void)showDatePicker
{
    _datePickerVisible=YES;
    NSIndexPath *indexPathDateRow=[NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker=[NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor=cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell=[self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker=(UIDatePicker *)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1&&indexPath.row==2)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.tag=100;
            [cell.contentView addSubview:datePicker];
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }
    else
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1 && _datePickerVisible)
    {
        return 3;
    }
    else
        return [super tableView:tableView numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1&&indexPath.row==2)
    {
        return 217.0f;
    }
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField resignFirstResponder];
    if(indexPath.section==1 && indexPath.row==1)
    {
        if(!_datePickerVisible)
        {
            [self showDatePicker];
        }
        else
        {
            [self hideDatePicker];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row==2)
    {
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    else
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

-(void)dateChanged:(UIDatePicker *)datePicker
{
    _dueDate=datePicker.date;
    [self updateDueDateLabel];
}

-(void)hideDatePicker
{
    if(_datePickerVisible)
    {
        _datePickerVisible=NO;
        NSIndexPath *indexPathDateRow=[NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker=[NSIndexPath indexPathForRow:2 inSection:1];
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hideDatePicker];
}
@end
