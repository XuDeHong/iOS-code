//
//  ViewController.m
//  CheckLists
//
//  Created by 许德鸿 on 16/1/15.
//  Copyright © 2016年 许德鸿. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
//{
//    NSMutableArray *_items;
//}

//-(void)loadChecklistItems
//{
//    NSString *path=[self dataFilePath];
//    if([[NSFileManager defaultManager]fileExistsAtPath:path])
//    {
//        NSData *data=[[NSData alloc]initWithContentsOfFile:path];
//        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
//        _items=[unarchiver decodeObjectForKey:@"ChecklistItems"];
//        [unarchiver finishDecoding];
//    }
//    else
//    {
//        _items=[[NSMutableArray alloc]initWithCapacity:20];
//    }
//}

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    if((self=[super initWithCoder:aDecoder]))
//    {
//        [self loadChecklistItems];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.checklist.name;
//    NSLog(@"文件夹的目录是：%@",[self documentsDirectory]);
    //NSLog(@"数据文件的最终路径是：%@",[self dataFilePath]);
    // Do any additional setup after loading the view, typically from a nib.
}

//-(NSString *)documentsDirectory
//{
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory=[paths firstObject];
//    return documentsDirectory;
//}

//-(NSString *)dataFilePath
//{
//    return [[self documentsDirectory]stringByAppendingPathComponent:@"Checklists.plist"];
//}

//-(void)saveChecklistItems
//{
//    NSMutableData *data=[[NSMutableData alloc]init];
//    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [archiver encodeObject:_items forKey:@"ChecklistItems"];
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.checklist.items count];
}


-(void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
     UILabel *label=(UILabel *)[cell viewWithTag:1001];
    if(item.checked){
        label.text=@"√";
    }
    else
        label.text=@"";
    label.textColor=self.view.tintColor;
}


-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item{
    UILabel *label=(UILabel *)[cell viewWithTag:1000];
    //label.text=item.text;
    label.text=[NSString stringWithFormat:@"%@",item.text];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CheckListItem"];
    ChecklistItem *item=self.checklist.items[indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    return cell;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item=self.checklist.items[indexPath.row];
    [item toggleChecked];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    //[self saveChecklistItems];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (IBAction)addItem:(id)sender {
//    NSInteger newRowIndex=[_items count];
//    ChecklistItem *item=[[ChecklistItem alloc]init];
//    item.text=@"新建事项";
//    item.checked=NO;
//    [_items addObject:item];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:newRowIndex inSection:0];
//    NSArray *indexPaths=@[indexPath];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    //[self saveChecklistItems];
    NSArray *indexPaths=@[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}



-(void)ItemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item{
    NSInteger newRowIndex=[self.checklist.items count];
    [self.checklist.items addObject:item];
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:newRowIndex inSection:0];
    NSArray *indexPaths=@[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    //[self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AddItem"]){
        UINavigationController *navigationController=segue.destinationViewController;
        ItemDetailViewController *controller=(ItemDetailViewController *)navigationController.topViewController;
        controller.delegate=self;
    }
    else if([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController=segue.destinationViewController;
        ItemDetailViewController *controller=(ItemDetailViewController *)navigationController.topViewController;
        controller.delegate=self;
        NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
        controller.itemToEdit=self.checklist.items[indexPath.row];
    }
}

-(void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item{
    NSInteger index=[self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    //[self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
